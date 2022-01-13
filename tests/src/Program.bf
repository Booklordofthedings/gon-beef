using System;
namespace tests
{
	class Program
	{
		public static void Main()
		{
			
			gon_beef.gon test =gon_beef.gon.Deserialize("""
				//USE THIS TO TEST THE STANDART
				t:value:key
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