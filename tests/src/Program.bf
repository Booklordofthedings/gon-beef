using System;
namespace tests
{
	class Program
	{
		public static void Main()
		{
			gon_beef.gon test =gon_beef.gon.Deserialize("""
				n:test:1
				b:sda:true
				o:test
				n:hello:1
				o:more
				n:hello:1
				O:more
				n:hello:1
				O:test
				""");
			for(gon_beef.line l in test.items)
			{
				Console.WriteLine(l.ToString(.. scope .()));
			}
			delete test;
			Result<char8> t = Console.Read();
		}
	}
}