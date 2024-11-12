unit Un_MenuLateral;

interface

uses Classes, SysUtils, StrUtils, DateUtils, Dialogs,
     Graphics,
     {$IFDEF VER220}
     Forms,
     ExtCtrls,
     Controls,
     Buttons,
     {$ELSE}
     Vcl.Forms,
     Vcl.ExtCtrls,
     Vcl.Controls,
     Vcl.Buttons,
     {$ENDIF}
     Un_MenuLateralDef;

const
   LARGURA_CONTRAIDA = 36;
   LARGURA_EXPANDIDA = 200;
   ALTURA_BOTAO = 38;
   INTERVALO = 100;
   INTERVALO_ONCLIQUE = 5000;

type

   TGraphicAccess = class(TGraphic)
   end;

   TmtMenuLateral = class( TComponent )
   private
      FAtivo: Boolean;
      FPainelFalso: TPanel;
      FPainelMenu: TPanel;
      FMenus: TmtMenus;
      FLog: TStrings;
      FLarguraExpandida: Integer;
      FPathImg: String;
      FListFunc: array of TNotifyEvent;


      FExecutei: Boolean;

      FTimer: TTimer;
      FTimerOnClique: TTimer;
      FAlturaBarraStatus: Integer;
      // FExpandir: Boolean;
      FExpandirNoClique: Boolean;

      FLigado: Boolean;
      FNomeFonte: String;
      FTamanhoFonte: Integer;

      procedure SetFAtivo(const Value: Boolean);
      procedure ConfiguraMenu( Painel: TPanel );

      procedure CriarPaineis;
      procedure DestruirPaineis;

      procedure SairDoComponente( Sender: TObject );
      procedure EntrarNoComponente( Sender: TObject );

      procedure SairNegrito( Sender: TObject );
      procedure EntrarNegrito( Sender: TObject );

      procedure LimparFoco;

      procedure MovimentarMenu;
      procedure CriarBotoes(Pn: TPanel; pai: String);
      procedure CriarPainelFilho(Botao: TSpeedButton);

      procedure DestruirPainelFilho(Painel: TPanel);

      procedure FechaMenu( Sender: TObject );
      procedure DesligaFLigado( Sender: TObject );

      procedure ImagemDefault( Img: TBitMap );
      procedure SetFCor(const Value: TColor);
      function GetFCor: TColor;

      procedure Clique( Sender: TObject );
      function GetFCorFonte: TColor;
      procedure SetFCorFonte(const Value: TColor);
      procedure SetFExpandirNoClique(const Value: Boolean);

   public
      property Ativo: Boolean    read FAtivo   write SetFAtivo;
      property Cor: TColor       read GetFCor  write SetFCor;
      property CorFonte: TColor  read GetFCorFonte  write SetFCorFonte;
      property NomeFonte: String read FNomeFonte    write FNomeFonte;
      property TamanhoFonte: Integer read FTamanhoFonte write FTamanhoFonte;
      property Menus: TmtMenus   read FMenus   write FMenus;
      property PathImg: String   read FPathImg write FPathImg;
      property Log: TStrings     read FLog              write FLog;
      property Largura: Integer  read FLarguraExpandida write FLarguraExpandida;
      property AlturaBarraStatus: Integer read FAlturaBarraStatus write FAlturaBarraStatus;
      // property Expandir: Boolean read FExpandir write FExpandir;
      property ExpandirNoClique: Boolean read FExpandirNoClique write SetFExpandirNoClique;

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
end;

   TmtConfiguraMenu = class( TComponent )
   private
      FMenus: TmtMenus;
   public
      property Menus: TmtMenus read FMenus write FMenus;
      constructor Create(AOwner: TComponent); override;
   end;

implementation

{ TmtMenuLateral }

procedure TmtMenuLateral.Clique(Sender: TObject);
var B: TSpeedButton;
    M: TmtMenu;
begin
   B := (Sender as TSpeedButton);

   if FExpandirNoClique then begin
      if not FLigado then begin
         FTimerOnClique.Enabled := false;
         FLigado := true;
         exit;
      end;
   end;

   if B.Owner <> FPainelMenu then begin
      B.OnMouseLeave := NIL;
      B.OnMouseEnter := NIL;
   end;
   M := FMenus.Localizar(B.Name);
   LimparFoco;
   MovimentarMenu;

   if FExpandirNoClique then begin
      FLigado := false;
   end;

   if Assigned(M.Procedimento) then
      M.procedimento( Self );
end;
// *****************************************************************************
procedure TmtMenuLateral.ConfiguraMenu(Painel: TPanel);
begin
   Painel.ParentBackground := false;
   Painel.ParentColor := false;
   Painel.Color := FMenus.CorNivel[0];
   Painel.BevelOuter := bvNone;
   Painel.ParentBackground := false;
   Painel.Font.Name := FNomeFonte;
   Painel.Font.Size := FTamanhoFonte;
   Painel.AlignWithMargins := false;
   Painel.Margins.Left := 0;
   Painel.Margins.Right := 0;
   Painel.Margins.Top := 0;
   Painel.Margins.Bottom := 0;
   Painel.ShowCaption := false;
end;
// *****************************************************************************
constructor TmtMenuLateral.Create(AOwner: TComponent);
begin
   inherited;
   FAtivo             := False;
   FLarguraExpandida  := LARGURA_EXPANDIDA;
   FAlturaBarraStatus := 0;
   FExpandirNoClique  := false;
   // FExpandir          := true;
   FLigado            := true;
   FMenus := TmtMenus.Create(Self);
   SetFCor( clSkyBlue );
   SetFCorFonte( clBlack );

   FTimer := TTimer.Create(Self);
   FTimer.Enabled  := false;
   FTimer.Interval := INTERVALO;
   FTimer.OnTimer  := FechaMenu;

   FTimerOnClique := TTimer.Create(Self);
   FTimerOnClique.Enabled  := false;
   FTimerOnClique.Interval := INTERVALO_ONCLIQUE;
   FTimerOnClique.OnTimer  := DesligaFLigado;

   FNomeFonte    := 'verdana';
   FTamanhoFonte := 8;

end;
// *****************************************************************************
procedure TmtMenuLateral.CriarBotoes(Pn: TPanel; pai: String);
var i: Integer;
    Botao: TSpeedButton;
begin
   for i := 0 to FMenus.Count-1 do begin
      if FMenus.Menu[i].Pai = pai then begin

         if FMenus.Menu[i].Visivel then begin
            Botao := TSpeedButton.Create(Pn);
            Botao.Parent  := Pn;

            Botao.Font.Color := FMenus.CorNivelFonte[FMenus.Menu[i].Nivel];
            Botao.Align   := alTop;
            Botao.Top     := 2000;
            Botao.Height  := ALTURA_BOTAO;
            Botao.Flat    := True;
            Botao.Margin  := 2;
            Botao.Name    := FMenus.Menu[i].Nome;
            Botao.Caption := FMenus.Menu[i].Caption;
            Botao.Hint    := FMenus.Menu[i].Hint;
            if Trim( FMenus.Menu[i].Hint ) <> '' then Botao.ShowHint := True;

            if FileExists( FPathImg + FMenus.Menu[i].Imagem ) then begin
               Botao.Glyph.LoadFromFile(FPathImg + FMenus.Menu[i].Imagem);
            end else begin
               ImagemDefault(Botao.Glyph);
            end;

            //if Assigned( FMenus.Menu[i].Procedimento ) then begin
            Botao.OnClick := Clique;
            //end else begin
            //   Botao.Font.Color := clGrayText;
           //  end;

            Botao.OnMouseEnter := EntrarNoComponente;
            Botao.OnMouseLeave := SairDoComponente;

            if Pn.Name <> 'FPainelMenu' then begin
               Pn.Height := ALTURA_BOTAO * Pn.ControlCount
            end;
         end;
      end;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.CriarPaineis;
begin
   FPainelFalso := TPanel.Create(Owner);
   FPainelFalso.Name   := 'FPainelFalso';
   FPainelFalso.Parent := TWinControl( Owner );
   FPainelFalso.Width  := LARGURA_CONTRAIDA -2;
   FPainelFalso.Align  := alLeft;

   FPainelMenu  := TPanel.Create(Owner);
   FPainelMenu.Name    := 'FPainelMenu';
   FPainelMenu.Parent  := TWinControl(Owner);
   FPainelMenu.Top     := 0;
   FPainelMenu.Left    := 0;
   FPainelMenu.Height  := TWinControl( Owner ).ClientHeight - FAlturaBarraStatus;
   FPainelMenu.Anchors := [akLeft, akTop, akBottom];
   FPainelMenu.Width   := LARGURA_CONTRAIDA;
   FPainelMenu.OnMouseLeave := SairDoComponente;
   FPainelMenu.OnMouseEnter := EntrarNoComponente;

   ConfiguraMenu(FPainelFalso);
   ConfiguraMenu(FPainelMenu);
   CriarBotoes(FPainelMenu,'');
end;
// *****************************************************************************
procedure TmtMenuLateral.CriarPainelFilho(Botao: TSpeedButton);
var PainelFilho: TPanel;
    NomePainel: String;
    xMenu: TmtMenu;
    i: Integer;
begin
   NomePainel := Botao.Name + '_Pn';

   PainelFilho := TPanel( Self.FindComponent(NomePainel) );
   xMenu := FMenus.Localizar(Botao.Name);

   if PainelFilho = NIL then begin
      PainelFilho := TPanel.Create(Self);
      PainelFilho.Name    := NomePainel;
      PainelFilho.Visible := false;

      PainelFilho.Parent := TWinControl( FPainelMenu.Owner );
      PainelFilho.Top    := Botao.Top + TPanel( Botao.Parent ).Top;
      //if FExpandir then begin
         PainelFilho.Left   := FPainelMenu.Width * xMenu.Nivel;
      //end else begin
      //   PainelFilho.Left   := ( LARGURA_EXPANDIDA * xMenu.Nivel ) - ( LARGURA_EXPANDIDA - LARGURA_CONTRAIDA );
      //end;

      PainelFilho.Width  :=  LARGURA_EXPANDIDA; // FPainelMenu.Width;
      PainelFilho.Height := 150;
      ConfiguraMenu(PainelFilho);
      PainelFilho.Color := FMenus.CorNivel[xMenu.Nivel];
      PainelFilho.Visible := true;
      CriarBotoes(PainelFilho,xMenu.Nome);
   end;

   // Verifica Filhos...
   if FLog <> NIL then
      FLog.Add('Verificando Filhos');

   for i := 0 to PainelFilho.ComponentCount-1 do begin
      Botao := TSpeedButton( PainelFilho.Components[i] );

      if FLog <> NIL then
         FLog.Add(Botao.Name);

      xMenu := FMenus.Localizar(Botao.Name);
      if xMenu.Foco then begin
         if FMenus.ContarFilhos(xMenu.Nome) > 0 then begin
            CriarPainelFilho(Botao);
         end;
      end;
   end;

   if FLog <> NIL then
      FLog.Add('Fim da verificação dos filhos');
end;
// *****************************************************************************
procedure TmtMenuLateral.DesligaFLigado(Sender: TObject);
begin
   FLigado := false;
   FTimerOnClique.Enabled := false;
end;

destructor TmtMenuLateral.Destroy;
begin
   FTimer.Enabled := false;
   FTimerOnClique.Enabled := false;

   FTimerOnClique.Free;
   FTimer.Free;
   SetFAtivo(false);
   FMenus.Free;
   inherited;
end;
// *****************************************************************************
procedure TmtMenuLateral.DestruirPaineis;
begin
   try
      FPainelMenu.Free;
   except
   end;
   try
      FPainelFalso.Free;
   except
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.DestruirPainelFilho(Painel: TPanel);
var cNome: String;
    xMenu: TmtMenu;
begin
   cNome := Painel.Name;
   cNome := Copy( cNome, 1, Length( cNome ) -3 ); // '_Pn'
   xMenu := FMenus.Localizar(cNome);
   if not xMenu.Foco then begin

      if FLog <> NIL then begin
         FLog.Add('Destruido: ' + Painel.Name);
      end;

      Painel.Free;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.EntrarNegrito(Sender: TObject);
begin
   if Sender.ClassType = TSpeedButton then begin
      TSpeedButton( Sender ).Font.Style := [TFontStyle.fsBold];
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.EntrarNoComponente(Sender: TObject);
var Componente: TWinControl;
    xMenu: TmtMenu;

   procedure LigarPai( _pai: String );
   begin
      xMenu := FMenus.Localizar(_pai);
      if xMenu <> NIL then begin
         xMenu.Foco := true;
         if xMenu.Pai <> '' then begin
            LigarPai( xMenu.Pai );
         end;
      end;
   end;

begin

   if FExpandirNoClique then begin
      if Not FLigado then begin
         exit;
      end;
   end;

   EntrarNegrito(Sender);
   Componente := TWinControl( Sender );
   FExecutei  := true;
   if FLog <> NIL then
      FLog.Add('TmtMenuLateral.EntrarNoComponente:' + Componente.Name);

   try
      if Componente.ClassType = TPanel then begin
         Componente.Tag := 1;
      end else begin
         FPainelMenu.Tag := 1;
         xMenu := FMenus.Localizar(Componente.Name);
         xMenu.Foco := True;
         LigarPai( xMenu.Pai );
      end;
      MovimentarMenu;
   except
      on E: Exception do begin
         if FLog <> NIL then begin
            FLog.Add('Erro: ' + E.Message);
         end else begin
            raise Exception.Create(E.Message);
         end;
      end;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.FechaMenu( Sender: TObject );
begin
   if not FExecutei then begin
      FExecutei := true;
      MovimentarMenu;

      if FExpandirNoClique then begin
         FTimerOnClique.Enabled := true;
      end;

   end;
   FTimer.Enabled := false;
end;
// *****************************************************************************
function TmtMenuLateral.GetFCor: TColor;
begin
   Result := FMenus.CorNivel[0];
end;
// *****************************************************************************
function TmtMenuLateral.GetFCorFonte: TColor;
begin
   Result := FMenus.CorNivelFonte[0];
end;
// *****************************************************************************
procedure TmtMenuLateral.ImagemDefault(Img: TBitMap);
const cHEX = '07544269746D617036100000424D361000000000000036000000280000002000'+
      '0000200000000100200000000000001000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '0000000000000000000000000000000000000000000000000000000000000000'+
      '000000000000000000000000000000000000AB998AF3AA9787FFA89584FFA894'+
      '83FFA89483FFA89483FFA89483FFA89483FFA89483FFA89483FFA89483FFA894'+
      '83FFA89483FFA89483FFA89483FFA89483FFA89483FFA89483FFA89483FFA894'+
      '83FFA89483FFA89483FFA89584FFAA9787FFAB998AF300000000000000000000'+
      '000000000000000000000000000000000000AA9687FFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA9687FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFFFFFFFF44BB'+
      '99FF4EBE9FFF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BF'+
      'A0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BFA0FF50BF'+
      'A0FF4EBE9FFF44BB99FFFFFFFFFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFFFFFFFF48B6'+
      '8EFF56BB96FF58BC98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC'+
      '98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC98FF58BC'+
      '98FF56BB96FF48B68EFFFFFFFFFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFFFFFFFF43AD'+
      '7FFF51B288FF53B38AFF53B38AFF53B38AFF53B38AFF53B38AFF53B38AFF53B3'+
      '8AFF53B38AFF53B38AFF53B38AFF53B38AFF53B38AFF53B38AFF53B38AFF53B3'+
      '8AFF51B288FF43AD7FFFFFFFFFFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFFFFFFFF33A1'+
      '68FF3EA670FF40A671FF40A671FF40A671FF40A671FF40A671FF40A671FF40A6'+
      '71FF40A671FF40A671FF40A671FF40A671FF40A671FF40A671FF40A671FF40A6'+
      '71FF3EA670FF33A168FFFFFFFFFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFEFDFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFEFDFFFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFFAFCFCFFBD9F'+
      '80FFC0A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A3'+
      '85FFC1A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A385FFC1A3'+
      '85FFC0A385FFBD9F80FFFAFCFCFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFF9FAFAFFFCFF'+
      'FFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFF'+
      'FFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFF'+
      'FFFFFEFFFFFFFCFFFFFFF9FAFAFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFF8F8FAFFBCA0'+
      '80FFBEA385FFBFA485FFBFA485FFBFA485FFBFA485FFBFA485FFBFA485FFBFA4'+
      '85FFBFA485FFBFA485FFBFA485FFBFA485FFBFA485FFBFA485FFBFA485FFBFA4'+
      '85FFBEA385FFBCA080FFF8F8FAFFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFF6F7F8FFFAFB'+
      'FFFFFCFEFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFF'+
      'FFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFFFFFFFCFF'+
      'FFFFFCFEFFFFFAFBFFFFF6F7F8FFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89483FFFFFFFFFFF5F6F8FFBCA0'+
      '80FFBFA385FFBFA486FFBFA486FFBFA486FFBFA486FFBFA486FFBFA486FFBFA4'+
      '85FFBFA485FFC1A484FFC1A484FFC1A484FFC1A484FFC1A484FFC1A484FFC1A4'+
      '84FFC1A383FFBEA07FFFF6F6F7FFFFFFFFFFA89483FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF4F4F6FFF8FA'+
      'FEFFFAFDFFFFFAFEFFFFFAFEFFFFFAFEFFFFFAFEFFFFFAFEFFFFFAFDFFFFFAFC'+
      'FFFFFDFAFBFFFFFAF9FFFFFBF8FFFFFCF7FFFFFCF7FFFFFCF7FFFFFCF7FFFFFC'+
      'F7FFFFFBF7FFFFF8F6FFF8F4F3FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF4F5F6FFBFA5'+
      '86FFC2A98DFFC3AA8EFFC3AA8EFFC3AA8EFFC3AA8EFFC3AA8EFFC2AA8DFFC2A6'+
      '87FFFFF9F6FF1DC4FFFF28C6FFFF2AC7FFFF2AC7FFFF2AC7FFFF2AC7FFFF2AC7'+
      'FFFF27C6FFFF1CC3FFFFFEF4EEFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF2F5F7FFC2A8'+
      '8BFFC5AE93FFC6AF94FFC6AF94FFC6AF94FFC6AF94FFC6AF94FFC5AE93FFC4AA'+
      '8CFFFFFAF6FF0098FFFF0B9BFFFF0E9BFFFF0E9BFFFF0E9BFFFF0E9BFFFF0E9B'+
      'FFFF0B9BFFFF0096FFFFFCF4EDFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF1F4F6FFC2A9'+
      '8DFFC6AF94FFC7B096FFC7B096FFC7B096FFC7B096FFC7B096FFC6AF94FFC4AA'+
      '8DFFF9F8F8FFFFF9F4FFFFFBF4FFFFFCF4FFFFFCF4FFFFFCF4FFFFFCF4FFFFFC'+
      'F4FFFFFBF4FFFFF7F2FFF4F1EFFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF0F3F4FFC2A8'+
      '8CFFC6AE93FFC6AF94FFC6AF94FFC6AF94FFC6AF94FFC6AF94FFC6AE93FFC3AA'+
      '8DFFF5F8FBFFC3A788FFC5AA8BFFC6AB8DFFC6AB8DFFC6AB8DFFC6AB8DFFC6AB'+
      '8DFFC5AA8BFFC2A586FFF0F2F2FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFEFF1F1FFC2A5'+
      '86FFC5AA8CFFC6AA8DFFC6AA8DFFC6AA8DFFC6AA8DFFC6AA8DFFC5AA8CFFC3A7'+
      '88FFF4F7FAFFC3AA8DFFC5AE93FFC6AF94FFC6AF94FFC6AF94FFC6AF94FFC6AF'+
      '94FFC5AE93FFC2A98CFFEFF2F3FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF0ECECFFFBF1'+
      'EFFFFFF4F0FFFFF4F0FFFFF4F0FFFFF4F0FFFFF4F0FFFFF4F0FFFFF4F0FFFCF2'+
      'F0FFF5F3F5FFC4AA8EFFC6AF94FFC7B096FFC7B096FFC7B096FFC7B096FFC7B0'+
      '96FFC6AF94FFC3AA8DFFEEEFF2FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF6ECE7FF1DC4'+
      'FFFF28C7FFFF2AC8FFFF2AC8FFFF2AC8FFFF2AC8FFFF2AC8FFFF28C7FFFF1EC5'+
      'FFFFFBF2F0FFC5AA8CFFC6AE93FFC7AF95FFC7AF95FFC7AF95FFC7AF95FFC7AF'+
      '95FFC6AE93FFC2A98CFFEDEEF1FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFF6EBE6FF0097'+
      'FFFF0C9BFFFF0E9CFFFF0E9CFFFF0E9CFFFF0E9CFFFF0E9CFFFF0C9BFFFF0198'+
      'FFFFF9F1EEFFC3A789FFC3AA8EFFC4AB90FFC4AB90FFC4AB90FFC4AB90FFC4AB'+
      '90FFC3AA8EFFC1A688FFEBECEEFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFEDE9E8FFF6EF'+
      'EDFFFBF2EFFFFCF2F0FFFCF2F0FFFCF2F0FFFCF2F0FFFCF2F0FFFBF2F0FFF6F1'+
      'F1FFEEEFF4FFEBF0F9FFEBF2FBFFEBF2FBFFEBF2FBFFEBF2FBFFEBF2FBFFEBF2'+
      'FBFFEBF2FAFFEAEEF5FFE8E9EBFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFE7E9EDFFEFB2'+
      '5CFFF0B665FFF0B766FFF0B766FFF0B766FFF0B766FFF0B766FFF0B766FFEFB7'+
      '66FFEEB667FFEDB668FFEDB768FFEDB768FFEDB768FFEDB768FFEDB768FFEDB7'+
      '68FFEDB666FFEDB25EFFE6E9EEFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFE6EAF1FFDDA4'+
      '52FFDEA95DFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA'+
      '5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA5FFFDEAA'+
      '5FFFDEA95DFFDDA452FFE6EAF1FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFE5EAF0FFCF95'+
      '41FFD19B4DFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C'+
      '4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C4FFFD19C'+
      '4FFFD19B4DFFCF9541FFE5EAF0FFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89484FFFFFFFFFFE4E7ECFFBD7F'+
      '24FFC0842EFFC08530FFC08530FFC08530FFC08530FFC08530FFC08530FFC085'+
      '30FFC08530FFC08530FFC08530FFC08530FFC08530FFC08530FFC08530FFC085'+
      '30FFC0842EFFBD7F24FFE4E7ECFFFFFFFFFFA89484FF00000000000000000000'+
      '000000000000000000000000000000000000A89584FFFFFFFFFFE1E2E4FFE3E6'+
      'EBFFE4E8EFFFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9'+
      'F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9F0FFE4E9'+
      'F0FFE4E8EFFFE3E6EBFFE1E2E4FFFFFFFFFFA89584FF00000000000000000000'+
      '000000000000000000000000000000000000AA9787FFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAA9787FF00000000000000000000'+
      '00000000000000000000000000000000000000000000AA9787FFA89584FFA894'+
      '84FFA89484FFA89484FFA89484FFA89484FFA89484FFA89484FFA89484FFA894'+
      '84FFA89484FFA89484FFA89484FFA89484FFA89484FFA89484FFA89484FFA894'+
      '84FFA89484FFA89484FFA89584FFAA9787FF0000000000000000000000000000'+
      '0000';
var Loutput :TMemoryStream;
    LclsName: ShortString;
begin
   Loutput := TMemoryStream.Create;
   try
      Loutput.Size := Length(cHex) div 2;
      HexToBin(PChar(cHex), Loutput.Memory^, Loutput.Size);

      LclsName := PShortString(Loutput.Memory)^;

      Loutput.Position := 1 + Length(LclsName);
      TGraphicAccess(Img).ReadData(Loutput);
   finally
      Loutput.Free;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.LimparFoco;
var _i: Integer;
begin
   FPainelMenu.Tag := 0;

   // Limpa Menus...
   for _i := 0 to FMenus.Count -1 do
      FMenus.Menu[_i].Foco := false;
end;
// *****************************************************************************
procedure TmtMenuLateral.MovimentarMenu;
var i: Integer;
    Botao: TSpeedButton;
    xMenu: TmtMenu;
begin
   if FPainelMenu.Tag = 1 then begin

//       if FExpandir then begin
          if FPainelMenu.Width <> FLarguraExpandida then
             FPainelMenu.Width := FLarguraExpandida;
//       end;

       for i := Self.ComponentCount-1 downto 0 do begin
          if Self.Components[i].ClassType = TPanel then begin
             DestruirPainelFilho( TPanel( Self.Components[i] ) );
          end;
       end;

       for i := FPainelMenu.ComponentCount -1 downto 0 do begin
          if FPainelMenu.Components[i].ClassType = TSpeedButton then begin
             Botao := TSpeedButton( FPainelMenu.Components[i] );
             xMenu := FMenus.Localizar(Botao.Name);
             if not xMenu.Foco then begin
                // DestruirPainelFilho( Botao );
             end else begin
                if FMenus.ContarFilhos(xMenu.Nome) > 0 then begin
                   CriarPainelFilho( Botao );
                end;
             end;
          end;
       end;

   end else begin

       // if FExpandir then begin
          if FPainelMenu.Width <> LARGURA_CONTRAIDA then
             FPainelMenu.Width := LARGURA_CONTRAIDA;
       // end;

       for i := Self.ComponentCount-1 downto 0 do begin
          if Self.Components[i].ClassType = TPanel then begin
             DestruirPainelFilho( TPanel( Self.Components[i] ) );
          end;
       end;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.SairDoComponente(Sender: TObject);
begin
   SairNegrito(Sender);
   LimparFoco;
   if FLog <> NIL then
      FLog.Add('TmtMenuLateral.SairDoComponente:' + TComponent(Sender).Name);

   FExecutei := false;
   FTimer.Enabled := true;
end;
// *****************************************************************************
procedure TmtMenuLateral.SairNegrito(Sender: TObject);
begin
   if Sender.ClassType = TSpeedButton then begin
      TSpeedButton( Sender ).Font.Style := [];
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.SetFAtivo(const Value: Boolean);
begin
   if (FAtivo = False) and (Value = true) then begin
      CriarPaineis;
      FAtivo := Value;
   end else if ( FAtivo = True ) and (Value = False) then begin
      DestruirPaineis;
      FAtivo := Value;
   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.SetFCor(const Value: TColor);
var i: Integer;
begin
   for i := 0 to 10 do
      FMenus.CorNivel[i] := Value;
end;
// *****************************************************************************
procedure TmtMenuLateral.SetFCorFonte(const Value: TColor);
var i: Integer;
begin
   for i := 0 to 10 do
      FMenus.CorNivelFonte[i] := Value;
end;
procedure TmtMenuLateral.SetFExpandirNoClique(const Value: Boolean);
begin
   FExpandirNoClique := Value;
   if Value then
      FLigado := false
   else
      FLigado := true;

end;

// *****************************************************************************
{ TmtConfiguraMenu }

constructor TmtConfiguraMenu.Create(AOwner: TComponent);
begin
   inherited;
   FMenus := TmtMenus.Create(Self);
end;

end.
