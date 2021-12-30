namespace tests
{
	class Program
	{
		public static void Main()
		{
			System.Console.WriteLine("Testing '${}'");
			System.Console.WriteLine("---------------------");
			int tests = 0;
			int succeses = 0;
			//Testing starts here

			//succeses += ParseSingleLine(); tests++;

			//Testing ends here
			System.Console.WriteLine("---------------------");
			System.Console.WriteLine($"{succeses} out of {tests} tests where successful");
			System.Console.Write("Press any key to close..");
			if(System.Console.Read() case .Ok)
				return;
		}

		public static void Completed(System.String name,int complete, int goal)
		{
			System.Console.WriteLine($"[{name}]:{(double)complete/(double)goal*100}%");
		}
	}
}