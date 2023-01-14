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

  var filename:String := '';
  var bucketName := '';


  if Console.IsInputRedirected then
  begin

    var stdin := String.Empty;

    using reader := new StreamReader(Console.OpenStandardInput(), Console.InputEncoding) do
    begin
      stdin := reader.ReadToEnd();
    end;


    if((stdin.Length>0) and (stdin.Contains(YamlHelpers.successText)))then
    begin
      bucketName := YamlHelpers.RetrieveFirstBucket(stdin);
      filename := OutputHelpers.ExtractFilename(stdin);
    end;

  end
  else
  begin
    var args := Environment.GetCommandLineArgs;

    if(args.Length = 3) then
    begin
      filename := args[1];
      bucketName := args[2];
    end
    else
    begin
      Console.WriteLine('No command line arguments passed you need 2 filename bucketname');
      exit;
    end;
  end;

  if(not String.IsNullOrEmpty(filename) and not String.IsNullOrEmpty(bucketName))then
  begin
    var s3Uri := await S3Upload.UploadToBucketAsync(filename, bucketName);
    Console.WriteLine($'Zip uploaded {filename} S3 Uri is {s3Uri}');
  end
  else
  begin
    Console.WriteLine('filename and bucketname not supplied');
  end;


end.