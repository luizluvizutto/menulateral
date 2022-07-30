unit Un_MenuLateralDef;

interface

uses Classes, SysUtils,
     Graphics;

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
      FPosicao: Integer;
      FVisivel: Boolean;
   public
      property Pai: String                read FPai          write FPai;
      property Nome: String               read FNome         write FNome;
      property Caption: String            read FCaption      write FCaption;
      property procedimento: TNotifyEvent read FProcedimento write FProcedimento;
      property imagem: String             read FImagem       write FImagem;
      property Foco: Boolean              read FFoco         write FFoco;
      property Nivel: Integer             read FNivel        write FNivel;
      property Posicao: Integer           read FPosicao      write FPosicao;
      property Visivel: Boolean           read FVisivel      write FVisivel;
   end;

   TmtMenus = class( TComponent )
   private
      FList: TList;
      FCores: array[0..10] of TColor;
      function GetMenu(index: Integer): TmtMenu;
      procedure SetMenu(index: Integer; const Value: TmtMenu);
      function GetFCores(index: Integer): TColor;
      procedure SetFCores(index: Integer; const Value: TColor);

   public
      property Menu[index: Integer]: TmtMenu read GetMenu   write SetMenu;
      property CorNivel[index: Integer]: TColor   read GetFCores write SetFCores;
      function Add( Pai, Nome, Caption: String; Procedimento: TNotifyEvent; Imagem: String ): TmtMenu;
      function Localizar( Nome: String ): TmtMenu;
      function Count: Integer;
      function ContarFilhos( nome: String ): Integer;

      function GetLista: String;
      procedure SetarLista( cLista: String );

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure Assign(Source: TPersistent); override;

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

      Result.Posicao := ContarFilhos(Pai) + 1;
      Result.Visivel := true;

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
procedure TmtMenus.Assign( Source: TPersistent );
var i: Integer;
    Origem: TmtMenus;

  procedure Copiar(_nome: String);
  var _i: Integer;
  begin
     for _i := 0 to Origem.Count -1 do begin
        if Origem.Menu[_i].Pai = _nome then begin
           Add( Origem.Menu[_i].Pai,
                Origem.Menu[_i].Nome,
                Origem.Menu[_i].Caption,
                Origem.Menu[_i].procedimento,
                Origem.Menu[_i].imagem
              );

           Copiar(Origem.Menu[_i].Nome);
        end;
     end;
  end;

begin
 //  inherited;

   for i := FList.Count -1 downto 0 do begin
      TComponent( FList[i] ).Free;
   end;

   if Source is TmtMenus then begin
      Origem := TmtMenus( Source );
      Copiar( '' );
   end;

 end;

function TmtMenus.GetFCores(index: Integer): TColor;
begin
   Result := FCores[index];
end;
// *****************************************************************************
function TmtMenus.GetLista: String;
var i: Integer;
    Lista: TStringList;

    function TF( _bool:boolean ): String;
    begin
       if _bool then
          Result := 'True'
       else
          Result := 'False';
    end;
begin
   Lista := TStringList.Create;
   try
      Result := '';
      for i := 0 to FList.Count -1 do begin
         Lista.Values[ TmtMenu( FList[i] ).Nome ] := TF( TmtMenu( FList[i] ).Visivel )
      end;
      Result := Lista.Text;
   finally
      Lista.Free;
   end;
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
procedure TmtMenus.SetarLista(cLista: String);
var Lista: TStringList;
    i: Integer;
    cValor: String;
begin
   Lista := TStringList.Create;
   try
      Lista.Text := cLista;
      for i := 0 to FList.Count -1 do begin

         cValor := Lista.Values[ TmtMenu( FList[i] ).Nome ];

         if LowerCase( cValor ) = 'true' then begin
            TmtMenu( FList[i] ).Visivel := true;
         end else if LowerCase( cValor ) = 'false' then begin
            TmtMenu( FList[i] ).Visivel := false;
         end;
      end;
   finally
      Lista.Free;
   end;
end;
// *****************************************************************************
procedure TmtMenus.SetFCores(index: Integer; const Value: TColor);
begin
   FCores[index] := Value;
end;
// *****************************************************************************
procedure TmtMenus.SetMenu(index: Integer; const Value: TmtMenu);
begin
   FList[index] := Value;
end;
// *****************************************************************************
end.
