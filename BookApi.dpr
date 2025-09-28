library BookApi;

uses
  Web.WebReq,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  BookModule in 'BookModule.pas' {BookWebModule: TWebModule};

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.WebModuleClass := TBookWebModule;
  Application.Run;
end.
