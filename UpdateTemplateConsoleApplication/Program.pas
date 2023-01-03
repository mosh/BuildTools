namespace UpdateTemplateConsoleApplication;


uses
  BuildTools.Core,
  System.Linq,
  System.IO,
  system.Text,
  System.Threading.Tasks;

begin

  var args := Environment.GetCommandLineArgs;

  if(args.Length <> 3) then
  begin
    Console.WriteLine('two arguments are required template and s3 resource');
    exit;
  end;

  var filename := args[1];
  var s3Resource := args[2];

  YamlHelpers.UpdateCodeUri(filename, s3Resource);

end.