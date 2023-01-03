namespace S3UploadConsoleApplication;


uses
  Amazon,
  Amazon.Runtime.CredentialManagement,
  Amazon.Runtime,
  Amazon.S3,
  Amazon.S3.Model,
  BuildTools.Core,
  System.Linq,
  System.IO,
  System.Net,
  System.Threading.Tasks;

begin

  var args := Environment.GetCommandLineArgs;

  if(args.Length = 3)then
  begin

    var filename:String := args[1];
    var bucketName := args[2];

    S3Upload.UploadToBucket(filename, bucketName);

  end
  else
  begin
    Console.WriteLine('No command line arguments passed you need 2 filename bucketname');
  end;


end.