namespace BuildTools.Core.Tests;

uses
  BuildTools.Core,  RemObjects.Elements.EUnit;

type
  OutputHelpersTests = public class(Test)
  private
  protected
  public
    method ExtractFilename;
    begin
      var value := $'{YamlHelpers.successText} /Users/JohnMoshakis/Documents/develop/Serverless-Oxgene-Lambda/zip/081706b4-49ba-4638-a32e-be7dea66f5cd.zip';
      var filename := OutputHelpers.ExtractFilename(value);
      Console.WriteLine(filename);
    end;
  end;

end.