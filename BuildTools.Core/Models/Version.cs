using System.Text;

namespace BuildTools.Core.Models
{
	public class Version : IComparable<Version>
	{
		private string _originalFilename;
		private string _filename;
		private List<int> _versions;

		public Version(string originalFilename, string filename, List<int> versions)
		{
			_originalFilename = originalFilename;
			_filename = filename;
			_versions = versions;
		}

		public string Filename
		{
			get
			{
				return _filename;
			}
		}

		public string OriginalFilename
		{
			get
			{
				return _originalFilename;
			}
		}

		public int[] Versions
		{
			get
			{
				return _versions.ToArray();
			}
		}

		public string Version
		{
			get
			{
				var builder = new StringBuilder();
				for(var x=0;x<_versions.Count;x++)
				{
					builder.Append($"{_versions[x]}");
					if(x<_versions.Count-1)
					{
						builder.Append('.');
					}
				}
				return builder.ToString();
			}
		}

		public int CompareTo(Version obj)
		{
			var filenameResult = string.Compare(_filename, obj.Filename,StringComparison.OrdinalIgnoreCase);

			if(filenameResult == 0)
			{
				for(var x=0;x<_versions.Count;x++)
				{
					if(_versions[x]<obj.Versions[x])
					{
						return -1;
					}
					else if(_versions[x]>obj.Versions[x])
					{
						return 1;
					}
				}
				return 0;
			}
			else
			{
				return filenameResult;
			}
		}
	}
}