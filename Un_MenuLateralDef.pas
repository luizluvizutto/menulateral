unit Un_MenuLateralDef;

interface

uses Classes, SysUtils;

type

   TmtMenu = class
   private
      FProcedimento: TNotifyEvent;
      FCaption: String;
      FNome: String;
      FPai: String;
      FImagem: String;
      FFoco: Boolean;
      FNivel: Integer;
   public
      property Pai: String                read FPai          write FPai;
      property Nome: String               read FNome         write FNome;
      property Caption: String            read FCaption      write FCaption;
      property procedimento: TNotifyEvent read FProcedimento write FProcedimento;
      property imagem: String             read FImagem       write FImagem;
      property Foco: Boolean              read FFoco         write FFoco;
      property Nivel: Integer             read FNivel        write FNivel;
   end;

   TmtMenus = class( TComponent )
   private
      FList: TList;
      function GetMenu(index: Integer): TmtMenu;
      procedure SetMenu(index: Integer; const Value: TmtMenu);
   public
      property Menu[index: Integer]: TmtMenu read GetMenu write SetMenu;
      function Add( Pai, Nome, Caption: String; Procedimento: TNotifyEvent; Imagem: String ): TmtMenu;
      function Localizar( Nome: String ): TmtMenu;
      function Count: Integer;
      function ContarFilhos( nome: String ): Integer;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   end;

implementation

{ TmtMenuDef }

function TmtMenus.Add(Pai, Nome, Caption: String; Procedimento: TNotifyEvent;
  Imagem: String): TmtMenu;
begin
   if Localizar(Nome) = NIL then begin
      Result := TmtMenu.Create;
      Result.Nome         := Nome;
      Result.Caption      := Caption;
      Result.Pai          := Pai;
      Result.procedimento := Procedimento;
      Result.Imagem       := Imagem;
      Result.Foco         := false;

      if Pai = '' then begin
         Result.Nivel := 1;
      end else begin
         Result.Nivel := Localizar(Pai).Nivel + 1;
      end;

      FList.Add(Result);
   end else begin
      raise Exception.Create('Existe um menu com o mesmo nome');
   end;
end;
// *****************************************************************************
function TmtMenus.ContarFilhos(nome: String): Integer;
var i: Integer;
begin
   Result := 0;
   for i := 0 to FList.Count -1 do begin
      if Menu[i].Pai = nome then begin
         Result := Result + 1;
      end;
   end;
end;
// *****************************************************************************
function TmtMenus.Count: Integer;
begin
   Result := FList.Count;
end;
// *****************************************************************************
constructor TmtMenus.Create(AOwner: TComponent);
begin
   inherited;
   FList := TList.Create;
end;
// *****************************************************************************
destructor TmtMenus.Destroy;
var i: Integer;
begin
   for i := FList.Count -1 downto 0 do begin
      TComponent( FList[i] ).Free;
   end;
   FList.Free;
   inherited;
end;
// *****************************************************************************
function TmtMenus.GetMenu(index: Integer): TmtMenu;
begin
   Result := TmtMenu( FList[index] );
end;
// *****************************************************************************
function TmtMenus.Localizar(Nome: String): TmtMenu;
var i: Integer;
begin
   Result := NIL;
   for i := 0 to FList.Count-1 do begin
      if ( TmtMenu( FList[i] ).Nome = Nome ) then begin
         Result := TmtMenu( FList[i] );
         Break;
      end;
   end;
end;
// *****************************************************************************
procedure TmtMenus.SetMenu(index: Integer; const Value: TmtMenu);
begin
   FList[index] := Value;
end;
// *****************************************************************************

end.
