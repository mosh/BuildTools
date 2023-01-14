namespace UpdateTemplateConsoleApplication;


uses
  BuildTools.Core,
  System.Linq,
  System.IO,
  system.Text,
  System.Threading.Tasks;

begin

  var templateFilename:String := nil;
  var s3Resource:String := nil;


  if Console.IsInputRedirected then
  begin

    var stdin := String.Empty;

    using reader := new StreamReader(Console.OpenStandardInput(), Console.InputEncoding) do
    begin
      stdin := reader.ReadToEnd;
    end;

    if(stdin.Contains(OutputHelpers.S3UriText) and stdin.Contains(OutputHelpers.ZipUploadedText))then
    begin

      var outputValues := OutputHelpers.ExtractS3Components(stdin);

      if(String.IsNullOrEmpty(outputValues.s3Resource) or String.IsNullOrEmpty(outputValues.filename))then
      begin
        Console.WriteLine($'Unable to find parameters from stdin [{stdin}]');
      end
      else
      begin
        s3Resource := outputValues.Item2;
        templateFilename := YamlHelpers.ExtractTemplateNameFromZip(outputValues.Item1);
        Console.WriteLine($'[{outputValues.Item1}]');
      end;
    end
    else
    begin
      Console.WriteLine('standardIn did not contain zip filename and  S3 uri');

      Console.WriteLine($'StandardIn was [{stdin}]');
    end;

  end
  else
  begin

    var args := Environment.GetCommandLineArgs;

    if(args.Length <> 3) then
    begin
      Console.WriteLine('two arguments are required template and s3 resource');
      exit;
    end;

    templateFilename := args[1];
    s3Resource := args[2];

  end;

  if String.IsNullOrEmpty(templateFilename) or String.IsNullOrEmpty(s3Resource) then
  begin
    Console.WriteLine('template filename or s3Resource could not be resolved');
    Console.WriteLine($'template filename was [{templateFilename}]');
    Console.WriteLine($'s3 resource was was [{s3Resource}]');
  end
  else
  begin
    YamlHelpers.UpdateCodeUri(templateFilename, s3Resource);
    Console.WriteLine($'S3 Resource [{s3Resource}]  was updated in template {templateFilename}');
  end;


end.