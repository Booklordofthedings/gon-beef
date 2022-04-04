using System;
namespace tests
{
	class Program
	{
		public static void Main()
		{
			//Console.WriteLine(bool.Parse("FALSE"));
			gon_beef.gon test =gon_beef.gon.Deserialize("""
				n:test:1213.4324324
				b:useless:true
				n:second:34432.3345
				o:lmao
				n:numbrs:23123213.21323
				b:worth:false
				O:lmao
				""");

			gon_beef.gon mask = scope gon_beef.gon();
			mask.items.Add(new .(.number,"test",null));
			mask.items.Add(new .(.number,"second",null));
			mask.items.Add(new .(.object,"lmao", new gon_beef.gon() ));
			mask.items[2].object.items.Add(new .(.number,"numbrs",null));
			test.MaskGON(ref mask);
			String outo  = gon_beef.gon.ToJSON(.. scope String(),mask,true);
			Console.Write(outo);
			delete test; 
			Result<char8> t = Console.Read();

		}
	}
}
