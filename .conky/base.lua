do
	local iconv=require("iconv")
	local toutf32 = iconv.new("UCS-4", "UTF8")
	local fromutf32 = iconv.new("UTF8", "UCS-4")
	local on_batt=0
	local first=true
	function trunc2(a,b)
		tmpa, err = toutf32:iconv(a)
		if string.len(tmpa)<4*b then
			b=string.len(tmpa)/4
		end
		tmpa = string.sub(tmpa,0,4*b)
		tmpa, err = fromutf32:iconv(tmpa)
		if err then
			print(err)
		end
		return tmpa
	end
	function trunc3(a,b)
		tmp=conky_parse(a)
		return trunc(tmp, b)
	end
	function trunc(a,b)
		a=string.gsub(a," ","");
		return trunc2(a,b)
	end
	function conky_trunc20(a)
		return trunc3(a, 20)
	end
	function conky_top()
		local t1=trunc3('${top name 1}',6)..conky_parse('${top cpu 1} ');
		local t2=trunc3('${top name 2}',6)..conky_parse('${top cpu 2} ');
		local t3=trunc3('${top name 3}',6)..conky_parse('${top cpu 3}');
		return t1..t2..t3;
	end
	function basename(k)
		return conky_parse('${exec basename \''..k..'\'}');
	end
	function conky_mpd_info(a)
		local a=trunc2(conky_parse('${mpd_artist}'),9);
		local s=trunc2(conky_parse('${mpd_title}'),21);
		local k;
		if(s ~= '' and s ~= nil and a~= nil and a ~= '' and s ~='(null)' and a ~= '(null)') then
			k=a..'-'..s;
		else
			k=conky_parse('${mpd_file}');
			k=basename(k);
			k=trunc(k,21);
		end
		local st=conky_parse('${mpd_status}');
		if st == 'Playing' then
			k=k;
		elseif st == 'Stopped' then
			k='^'..k;
		elseif st == 'Paused' then
			k=k..' P';
		end
		if conky_parse('${mpd_repeat}') == 'On' then
			k=k..' R';
		end
		if string.find(conky_parse('${exec mpc}'),'single: on') then
			k=k..' S';
		end
		if conky_parse('${mpd_random}') == 'On' then
			k=k..' X';
		end
		k=k..conky_parse(' ${mpd_vol}%');
		return k;
	end
	function conky_if_discharging()
		local tmp=conky_parse('${battery}');
		if string.find(tmp,'discharging') then
			if on_batt == 0 then
				conky_set_update_interval(20.0);
				on_batt=1;
			end
			return '1';
		else
			if on_batt == 1 then
				conky_set_update_interval(1.0);
				on_batt=0;
			end
			return '0';
		end
	end
	function conky_if_batt()
		local tmp=conky_parse('${battery}');
		if string.find(tmp,'charging') then
			return '1';
		else
			return '0';
		end
	end
	function conky_avgfreq()
		local fr1,fr2,fr3,fr4=conky_parse('${freq 1}'),conky_parse('${freq 2}'),conky_parse('${freq 3}'),conky_parse('${freq 4}');
		return (fr1+fr2+fr3+fr4)/4;
	end
	function conky_i3bar()
		if first then
			first = false;
			return "{\"version\":1}\n[\n";
		else
			return ",";
		end
	end
	local threshold=78
	function conky_high_temp()
		local tmp=tonumber(conky_parse('${acpitemp}'))
		if tmp>threshold then
			return "true";
		else
			return "false";
		end
	end
end
