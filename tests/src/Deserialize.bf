using System;
//using gon_beef;
namespace gon_beef
{
	//TODO: ACTUAL TESTS
	extension gon
	{
		
		///Parse a single line and return the input if it parsed as expected
		public static Result<line> t_sline(String input,bool expected = true)
		{
			Result<line> res = ParseLine(input);
			if(expected)
			{
				if(res == .Err)
					Console.WriteLine($"Error trying to parse '{input}'");
				else
					return res;
			}
			else
			{
				if(res case .Ok(let t))
					Console.WriteLine($"Error trying to parse '{input}'");
				else
					return res;
			}
			return .Err;
		}
	}
}

static
{
	[Test]
	public static void t_ParseSingleLine()
	{
		Console.WriteLine("Tests regarding the correct parsing of a single line of string");
		int tests = 0; //The number of tests in this method
		int p = 0; //The number of positive tests (tests with the expected outputs)

		//Regular Inputs
		if(gon_beef.gon.t_sline("n:number:1") case .Ok(let val)) 
		{
			if(val.type == .number && val.name == "number" && val.value == "1")
				p++;
			else
				Console.WriteLine("error in expected values when parsing: 'n:number:1'");
			delete val;        
		}tests++;
		if(gon_beef.gon.t_sline("n:count:600") case .Ok(let val)) 
		{
			if(val.type == .number && val.name == "count" && val.value == "600")
				p++;
			else
				Console.WriteLine("error in expected values when parsing: 'n:count:600'");
			delete val;        
		}tests++;
		if(gon_beef.gon.t_sline("n:string:69420") case .Ok(let val)) 
		{
			if(val.type == .number && val.name == "string" && val.value == "69420")
				p++;
			else
				Console.WriteLine("error in expected values when parsing: 'n:string:69420'");
			delete val;    
		}tests++;

		//Special Numbers
		if(gon_beef.gon.t_sline("n:number:3728572345984754357435435") case .Ok(let val)) 
		{
			if(val.type == .number && val.name == "number" && val.value == "3728572345984754357435435")
				p++;
			else
				Console.WriteLine("error in expected values when parsing: 'n:number:3728572345984754357435435'");
			delete val;
		}tests++; 
		double x  = 3728572345984754357435435d;

		if(tests == p)
			return;
		else
			System.Runtime.FatalError();
	}
}

	