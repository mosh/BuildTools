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

      var param1 := String.Empty;
      var param2 := String.Empty;

      if Console.IsInputRedirected then
      begin

        var standardIn := String.Empty;

        using reader := new StreamReader(Console.OpenStandardInput(), Console.InputEncoding) do
        begin
          standardIn := reader.ReadToEnd();
        end;

        if(standardIn.Length>0)then
        begin
          var standardInArgs := standardIn.Split(' ');

          param1 := standardInArgs[0].ReplaceLineEndings('');
          param2 := standardInArgs[1].ReplaceLineEndings('');

        end;

      end
      else
      begin

        if(args.Length <> 2)then
        begin
          Console.WriteLine('You must supply the source and destination directory names');
          exit;
        end;

        param1 := args[0];
        param2 := args[1];

      end;

      if(not String.IsNullOrEmpty(param1) and not String.IsNullOrEmpty(param2))then
      begin

        if (not Directory.Exists(param1))then
        begin
          Console.WriteLine($'Source directory [{param1}] does not exist');
          exit;
        end;

        if (not Directory.Exists(param2))then
        begin
          Console.WriteLine($'Destination directory [{param2}] does not exist');
          exit;
        end;

        var sourceDirectory := param1;
        var destinationName := $'{Guid.NewGuid.ToString}.zip';
        var destinationFullPath := Path.Combine(param2,destinationName);

        ZipFile.CreateFromDirectory(sourceDirectory, destinationFullPath);
        Console.WriteLine($'Created {destinationFullPath}');
      end
      else
      begin
        Console.WriteLine('Failed to provide arguments');
      end;



    end;

  end;

end.