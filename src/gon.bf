#region Intro
/* ---gon-beef---
	
	A single file GON parser for the beef programming language.

	GON stands for Generic Object Notation and is a simple way
	of serializing any possible object in a human read- and write-
	able way.
	It is also very easy to parse, so that a rewrite into a different
	language should be easily doable.

	This Project/File/Notation is licensed under the Mit license
	(C)2021 Jannis-Leander von Hagen
*/
#endregion
#region Documentation
/*
	This file includes an extensive documentation of all required and optional features
	this parser has and other parsers should implement, so that its easy to understand.

	Standard:
	- A general GON file should use a .gon file extension and use the first line to identify its type, unless otherwise necessary
	- The file will be parsed line by line, using newline as the divider. (This makes it harder to multithread parse, but it makes it easier to parse)
		(Data that has a \n in the original should be parsed to only fill a single line. In beef there is a QuoteString() method that allows this)
	- A line may start with any amount of control characters, like tabs or spaces, those will be removed before it is parsed
	- The structure for a line is as follows:
		[Type]:[Name]:[Value]

		[Type] = Single character that specifies the type of the object in the line
			- n = floating point number
			- t = string of text
			- b = bool
			- o = object
			- O = end of object
			- c = a custom type. if its a c, then there needs to be a [TypeName]: in between [Type] and [Name] to specify what it is.
	- Lines that do not follow that structure will be ignored
*/
#endregion
using System;
using System.Collections;
namespace gon_beef
{
	class gon
	{
#region Serializing
#endregion
#region Deserialize
		public static gon Deserialize(String object)
		{
			//Spliting the string
			List<String> Lines = scope .();
			StringSplitEnumerator div = object.Split('\n');
			for(StringView v in div)
			{
				String line = new String(v); //So that the user may delete the input string
				line.TrimStart(); //Remove tabs and spaces from the start

				if(line.StartsWith('n') || line.StartsWith('t') || line.StartsWith('b') || line.StartsWith('c') || line.StartsWith('o') || line.StartsWith('O')) //Only valid lines from here onward
					Lines.Add(line);
				else
					delete line;
			}

			gon output = new .();
			for(String s in Lines)
			{
				if(!(s.StartsWith('o') || s.StartsWith('O')))
				{
					//This should be faster than checking the opposite
					//This is for normal items
					if(ParseLine(s) case .Ok(let val))
						output.items.Add(val);
				}
				//TODO: Parse Lines
				//TODO: object parser
			}

			
			return null;
		}

		///Returns a Line object created from the String
		private static Result<line> ParseLine(String LineIn)
		{
			var items = scope List<StringView>(LineIn.Split(':'));
			if(LineIn[0] == 'n') //Number
			{
				if(items.Count < 3)
					return .Err;
				if(double.Parse(items[2]) case .Err)
					return .Err;

				return .Ok(new line(.number, new String(items[1]), new String(items[2])));
			}
			else if(LineIn[0] == 'b') //Bool
			{
				if(items.Count < 3)
					return .Err;
				if(bool.Parse(items[2]) case .Err)
					return .Err;

				return .Ok(new line(.bool, new String(items[1]), new String(items[2])));
			}
			else if(LineIn[0] == 't') //Text
			{
				if(items.Count < 3)
					return .Err;

				return .Ok(new line(.string, new String(items[1]), new String(items[2])));
			}
			else if(LineIn[0] == 'c') //Custom
			{
				if(items.Count < 4)
					return .Err;

				return .Ok(new line(.custom,new String(items[1]), new String(items[2]), new String(items[3]))); //The second entry denotes the type
			}
			return .Err;
		}
#endregion
#region Acess
		public List<line> items;
#endregion
	}

	//This is the class that the end user actually gets from the gon object
	class line
	{
		public enum Type
		{
			number,
			bool,
			string,
			object,
			custom
		}
		/* Permanent members */
		public System.String name; //Name of the object
		public System.String value; //The current value assigned to the object as a String
		public Type type; //The type of the object
		/* Optional members */
		public System.String type_name; //The name of the type of the object (Only exists, if type is custom)
		public gon object; //If type is object this contains the object

		//Destructor, that just clears all objects
		public ~this()
		{
			delete name;
			delete value;
			delete type_name;
			delete object;
		}

		//Constructor default
		public this(Type _type, System.String _name, System.String _value)
		{
			type = _type;
			name = new .(_name);
			value = new .(_value);
		}
		//Constructor for custom types
		public this(Type _type,System.String _type_name, System.String _name, System.String _value)
		{
			type = _type;
			name = new .(_name);
			value = new .(_value);
		}
		//Constructor for objects
		public this(Type _type, System.String _name, gon _object)
		{
			type = _type;
			name = new .(_name);
			object = _object;
		}


	}
}
