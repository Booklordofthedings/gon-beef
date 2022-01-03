using System;
namespace tests
{
	class Program
	{
		public static void Main()
		{
			gon_beef.gon test =gon_beef.gon.Deserialize("""
				n:test:1
				""");
			Console.WriteLine(test.items[0].type);
			delete test;
			Console.ReadLine(scope .());

			Console.ReadLine(scope .());
		}
	}
}