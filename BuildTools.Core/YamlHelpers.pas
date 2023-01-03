namespace BuildTools.Core;

uses
  System.IO,
  System.Text;

type
  YamlHelpers = public class
  private
  protected
  public
    class method UpdateCodeUri(filename:String; s3Resource:String);
    begin
      var code := 'CodeUri:';
      var newLines := new StringBuilder;

      if(File.Exists(filename))then
      begin
        var lines := File.ReadAllLines(filename);

        for each line in lines do
          begin
          if line.Contains(code) then
          begin
            var x := line.IndexOf(code)+code.Length;

            var replaced := line.Replace(line.Substring(x),$' {s3Resource}');
            newLines.AppendLine(replaced+'');
          end
          else
          begin
            newLines.AppendLine(line);
          end;
        end;

        var backupFilename := Path.ChangeExtension(filename, '.yaml.old');

        if(File.Exists(backupFilename))then
        begin
          Console.WriteLine('Removing old backup');
          File.Delete(backupFilename);
        end;

        Console.WriteLine($'Copying {filename} to {backupFilename}');
        File.Copy(filename, backupFilename);

        if(File.Exists(backupFilename))then
        begin
          Console.WriteLine('Removing existing file');
          File.Delete(filename);
          Console.WriteLine('Writting new file');
          File.WriteAllText(filename, newLines.ToString);
          Console.WriteLine($'Written new file {filename}');

        end
        else
        begin
          Console.WriteLine($'Backup file {backupFilename} could not be created');
        end;

      end
      else
      begin
        Console.WriteLine($'{filename} does not exist');
      end;

    end;
  end;

end.