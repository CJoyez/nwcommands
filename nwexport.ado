*! Date        : 3sept2014
*! Version     : 1.0.1
*! Author      : Thomas Grund, Link�ping University
*! Email	   : contact@nwcommands.org

capture program drop nwexport
program nwexport
	version 9
	syntax [anything(name=netname)],[FName(string asis) replace]	
	
	_nwsyntax `netname', max(1)
	
	if ("`path'" != ""){
		local last = substr("`path'", -1, .)
		if ("`last'" != "/" | "`last'" != "\"){
			local path = "`path'/"
		}
	}
	
	di `"`fname'"'
	
	scalar onevars = "\$nw_`id'"
	local vars `=onevars'
	
	if (`"`fname'"' == "") {
		local fname "`name'.net"
	}

	di `"{txt}Exporting network: `fname'"'
	di `"file open expfile using `path'`fname', write `replace'"'
	
	file open expfile using `"`path'`fname'"', write `replace'
	file write expfile "*Vertices `nodes'" _newline
	forvalues i = 1/`nodes' {
		file write expfile (`i')
		file write expfile (" ")
		file write expfile (char(34))
		local onevar : word `i' of `vars'
		file write expfile ("`onevar'")
		file write expfile (char(34)) _newline	
	}
	if ("`directed'" == "true"){
		file write expfile "*Arcs"
	}
	else {
		file write expfile "*Edges"
	}
	
	preserve
	nwtoedge `netname'
	local ties = _N
	forvalues i = 1/`ties' {
		if `netname'[`i'] != 0 {
			local value = `netname'[`i']
			local k = _fromid[`i']
			local l = _toid[`i']
			file write expfile _newline
			file write expfile (`k')
			file write expfile " "
			file write expfile (`l')
			file write expfile " `value'" 	
		}
	
	}
	file write expfile "" _n
	file close expfile	
	restore
end
