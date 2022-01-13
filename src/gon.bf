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

	TODO:Improve documentation and readme
*/
#endregion
using System;
using System.Collections;
namespace gon_beef
{
	class gon
	{
#region Serializing
		//TODO: add an easy way to serialize gon objects
		//TODO: Serialize ToJSON
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
			for(int i < Lines.Count)
			{
				if(!(Lines[i].StartsWith('o') || Lines[i].StartsWith('O')))
				{
					//This should be faster than checking the opposite
					//This is for normal items
					if(ParseLine(Lines[i]) case .Ok(let val))
						output.items.Add(val);
				}
				else //Oboi its an object
				{
					if(ParseGon(ref i,Lines) case .Ok(var val))
						output.items.Add(val);
				}
					
					
			
			}
			ClearAndDeleteItems!(Lines);
			
			return output;
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

				return .Ok(new line(.number, items[1], items[2]));
			}
			else if(LineIn[0] == 'b') //Bool
			{
				if(items.Count < 3)
					return .Err;
				if(bool.Parse(items[2]) case .Err)
					return .Err;

				return .Ok(new line(.bool, items[1], items[2]));
			}
			else if(LineIn[0] == 't') //Text
			{
				if(items.Count < 3)
					return .Err;

				return .Ok(new line(.string, items[1], items[2]));
			}
			else if(LineIn[0] == 'c') //Custom
			{
				if(items.Count < 4)
					return .Err;

				return .Ok(new line(.custom,items[1], items[2], items[3])); //The second entry denotes the type
			}
			return .Err;
		}

		//Return the gon object
		private static Result<line> ParseGon(ref int index, List<String> view)
		{
			//Figure out the name of the object
			StringView name = view[index];
			List<StringView> h =scope List<StringView>(view[index].Split(':'));

			String ending = scope .(name);
			ending[0] = 'O'; //Set the end of the object

			int counter = 1;
			int end = index;
			index++;
			for(int i = index;  i < view.Count;i++)
			{
				if(view[i] == name)
					counter++;
				else if(view[i] == ending)
					counter--;

				if(counter == 0) //found the end of the object
				{
					end = i; //Mark the end of the object
					break;
				}
			}
				if(end != 0) //we found something
				{
					String objectS = scope System.String(); //String to attach to
					for(int i2 = index;  i2 < end; i2++)
					{
						objectS.Append(view[i2]);
						objectS.Append('\n');
					}

					line output = new .(.object,h[1],Deserialize(objectS));
					index = ++end;
					return output;
				}
			
			return .Err;
		}

#endregion
#region Acess
		//TODO: Improve ways acessing and filtering parsed objects
		public List<line> items; //You can acess this directly, but you probably should use the gon object directly

		//Accessing via string
		public ref line this[String key]
		{
			public get //Returns the first line with the given name and fatal errors if it doesn't exist
			{
				for(int i < items.Count)
				{
					if(items[i].name == key)
						return ref items[i];
				}
				Runtime.FatalError("No object of this name found");
			}
		}

		//Accessing via index
		public ref line this[int key]
		{
			public get //Returns the line at the given index and fatal errors if it doesn't exist
			{
				if(key < items.Count && key >= 0)
					return ref items[key];
				Runtime.FatalError("Index out of scope error");
			}
		}

		//Searching methods
		///Returns every line
		public Selection Search() => Search(false,false,false);
		///Returns all lines of a given type
		/// @param cType cType needs to be given if t = .custom otherwise it wont work as expected
		public Selection Search(line.Type t, String cType = "none") => Search(true,false,false,t,"default",cType);
		///Return all lines of a given name
		///Full searching method. to complex to use which why there are "api" methods connecting to this one
		private Selection Search(bool doType, bool doName, bool doCType,line.Type t = .string, String name = "default", String cType = "none")
		{
			Runtime.FatalError("NotImplementedYet  Error");
		}
		
#endregion

		public this() //The constructor just initializes the list
		{
			items = new System.Collections.List<gon_beef.line>();
		}
		public ~this() //Cleanup
		{
			DeleteContainerAndItems!(items);
		}
		
	} //End of gon class

	//This is the class that the end user actually gets from the gon object
	class line
	{
		//TODO: Write proper acessors to the data laying behind a type
		//TODO: add a static dictionary for generic custom types to be parsed Dictionary<String,T Function(String input)> | T = custom type
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

		//Constructor default
		public this(Type _type, System.StringView _name, System.StringView _value)
		{
			type = _type;
			name = new .(_name);
			value = new .(_value);
		}
		//Constructor for custom types
		public this(Type _type,System.StringView _type_name, System.StringView _name, System.StringView _value)
		{
			type = _type;
			type_name = new .(_type_name);
			name = new .(_name);
			value = new .(_value);
		}
		//Constructor for objects
		public this(Type _type, System.StringView _name, gon _object)
		{
			type = _type;
			name = new .(_name);
			object = _object;
		}

		//TODO:Cleanup the to string method
		public override void ToString(String strBuffer)
		{
			strBuffer.Append(this.type.ToString(.. scope .()));
			strBuffer.Append('\n');
			if(this.type == .custom)
			{
				strBuffer.Append(this.type_name);
				strBuffer.Append('\n');
			}
			strBuffer.Append(this.name);
			strBuffer.Append('\n');
			if(this.type == .object)
			{
				strBuffer.Append('{');
				strBuffer.Append('\n');
				for(line l in this.object.items)
				{
					strBuffer.Append(l.ToString(.. scope .()));
				}
				strBuffer.Append('\n');
				strBuffer.Append('}');

			}
			else
			{
				strBuffer.Append(this.value);
				strBuffer.Append('\n');
				strBuffer.Append("----ItemEnd----\n");
			}
		} //ToString end
	} //line class end

	struct  Selection //This will be returned, if you search the gon object
	{
		line*[] items;
	}

}
