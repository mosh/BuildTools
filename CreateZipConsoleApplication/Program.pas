namespace CreateZipConsoleApplication;


uses
  System.Linq,
  System.IO,
  System.IO.Compression,
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

      if (not Directory.Exists(args[1]))then
      begin
        Console.WriteLine('Destination directory does not exist');
        exit;
      end;

      var sourceDirectory := args[0];
      var destinationName := $'{Guid.NewGuid.ToString}.zip';
      var destinationFullPath := Path.Combine(args[1],destinationName);

      ZipFile.CreateFromDirectory(sourceDirectory, destinationFullPath);

      Console.WriteLine($'Created {destinationFullPath}');

      exit 0;
    end;
  end;

end.