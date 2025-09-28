unit BookModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.JSON,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TBookWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure GetBooksHandler(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  end;

implementation

procedure TBookWebModule.WebModuleCreate(Sender: TObject);
begin
  Actions.Add.PathInfo := '/books';
  Actions.Add.OnAction := GetBooksHandler;
end;

procedure TBookWebModule.GetBooksHandler(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Conn: TFDConnection;
  Query: TFDQuery;
  List: TJSONArray;
  Item: TJSONObject;
begin
  Conn := TFDConnection.Create(nil);
  Query := TFDQuery.Create(nil);
  List := TJSONArray.Create;
  try
    Conn.Params.Text :=
      'DriverID=MSSQL;' +
      'Server=.\SQLEXPRESS;' +
      'Database=BookCatalog;' +
      'User_Name=sa;' +
      'Password=SecurePass123;' +
      'LoginPrompt=No;' +
      'Encrypt=No;' +
      'TrustServerCertificate=True;';
    Conn.Connected := True;

    Query.Connection := Conn;
    Query.SQL.Text :=
      'SELECT b.Title, b.Author, g.Name AS Genre, b.Price ' +
      'FROM Books b ' +
      'LEFT JOIN Genres g ON b.GenreId = g.Id';
    Query.Open;

    while not Query.Eof do
    begin
      Item := TJSONObject.Create;
      Item.AddPair('title', Query.FieldByName('Title').AsString);
      Item.AddPair('author', Query.FieldByName('Author').AsString);
      Item.AddPair('genre', Query.FieldByName('Genre').AsString);
      Item.AddPair('price', Query.FieldByName('Price').AsFloat);
      List.AddElement(Item);
      Query.Next;
    end;

    Response.ContentType := 'application/json; charset=utf-8';
    Response.Content := List.ToJSON;
    Response.SendResponse;
  except
    on E: Exception do
    begin
      Response.StatusCode := 500;
      Response.Content := '{"error":"Database error: ' + E.Message + '"}';
      Response.SendResponse;
    end;
  end;
  Handled := True;
end;

end.
