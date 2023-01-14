namespace BuildTools.Core.Tests;


uses
  RemObjects.Elements.EUnit;

begin

  var lTests := Discovery.FromType(typeOf(OutputHelpersTests));

  Runner.RunTests(lTests) withListener(new ConsoleTestListener());


end.