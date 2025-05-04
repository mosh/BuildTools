namespace DeployLibrariesConsoleApplication;


uses
  BuildTools.Core,
  System.Linq,
  System.IO,
  System.Threading.Tasks;

type

  Program = class
  public
    class method Main(args: array of String): Integer;
    begin


      if(args.Length <> 2)then
      begin
        Console.WriteLine('You must supply the source and destination directory names');
        exit;
      end;

      //var sourceFolder := '/Users/JohnMoshakis/Documents/develop/Moshine.Foundation/Moshine.Foundation.AWS/Bin/Release';
      //var destinationFolder := '/Users/JohnMoshakis/Documents/develop/local-nuget';

      var sourceFolder := args[0];
      var destinationFolder := args[1];

      if not Directory.Exists(sourceFolder) then
      begin
        raise new Exception($'{sourceFolder} does not exist');
      end;

      if not Directory.Exists(destinationFolder) then
      begin
        raise new Exception($'{destinationFolder} does not exist');
      end;

      var versions := NuPkgUtilities.GetVersions(sourceFolder);

      if versions.Any() then
      begin
        var latestPackage := versions.First;

        var packageFile := Path.GetFileName(latestPackage.OriginalFilename);

        var destinationPackage := Path.Combine(destinationFolder, packageFile);

        if(not File.Exists(destinationPackage))then
        begin
          Console.WriteLine($'Copying {latestPackage.OriginalFilename} to {destinationPackage}');
          File.Copy(latestPackage.OriginalFilename, destinationPackage,false);
        end
        else
        begin
          Console.WriteLine($'Already copied {latestPackage.OriginalFilename} to {destinationPackage}');
        end;


      end;

    end;
  end;



end.