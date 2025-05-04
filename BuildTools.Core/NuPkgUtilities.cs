using System.IO;
using System.Text.RegularExpressions;
using BuildTools.Core.Models;

namespace BuildTools.Core
{
	public class NuPkgUtilities
	{
		public static List<Version> GetVersions(string baseFolder)
		{
			var files = Directory.GetFiles(baseFolder, "*.nupkg");

			var version = new Regex("(\\d+.\\d+.\\d+)");

			var versions = new List<Version>();

			if(files.Any())
			{
				foreach(var file in files)
				{
					var match = version.Match(file);

					if(match.Success)
					{
						var values = match.Value.Split('.').Select(s => Convert.ToInt32(s));

						var beforeVersion = file.Substring(0, match.Index-1);

						var withoutVersion = $"{beforeVersion}.nupkg";

						var someVersion = new Version(file, withoutVersion, values.ToList());
						versions.Add(someVersion);
					}
				}

				return versions.OrderByDescending(x => x).ToList();
			}
			return versions;
		}
	}
}