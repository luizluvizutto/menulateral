unit Un_MenuLateral;

interface

uses Classes, SysUtils, StrUtils, DateUtils, Dialogs,
     Graphics,
     Vcl.Forms,
     Vcl.ExtCtrls,
     Vcl.Controls,
     Vcl.Buttons,
     Un_MenuLateralDef;

const
   LARGURA_CONTRAIDA = 36;
   LARGURA_EXPANDIDA = 200;
   ALTURA_BOTAO = 45;
   INTERVALO = 400;

type

   TmtMenuLateral = class( TComponent )
   private
      FAtivo: Boolean;
      FPainelFalso: TPanel;
      FPainelMenu: TPanel;
      FCor: TColor;
      FMenus: TmtMenus;
      FLog: TStrings;
      FLarguraExpandida: Integer;
      FPathImg: String;

      FExecutei: Boolean;

      FTimer: TTimer;

      procedure SetFAtivo(const Value: Boolean);
      procedure ConfiguraMenu( Painel: TPanel );

      procedure CriarPaineis;
      procedure DestruirPaineis;

      procedure SairDoComponente( Sender: TObject );
      procedure EntrarNoComponente( Sender: TObject );

      procedure LimparFoco;

      procedure MovimentarMenu;
      procedure CriarBotoes(Pn: TPanel; pai: String);
      procedure CriarPainelFilho(Botao: TSpeedButton);
      procedure DestruirPainelFilho(Botao: TSpeedButton);

      procedure FechaMenu( Sender: TObject );


   public
      property Ativo: Boolean   read FAtivo   write SetFAtivo;
      property Cor: TColor      read FCor     write FCor;
      property Menus: TmtMenus  read FMenus   write FMenus;
      property PathImg: String  read FPathImg write FPathImg;
      property Log: TStrings    read FLog              write FLog;
      property Largura: Integer read FLarguraExpandida write FLarguraExpandida;

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   end;

implementation

{ TmtMenuLateral }

procedure TmtMenuLateral.ConfiguraMenu(Painel: TPanel);
begin
   Painel.ParentBackground := false;
   Painel.ParentColor := false;
   Painel.Color := FCor;
   Painel.BevelOuter := bvNone;
   Painel.ParentBackground := false;
   Painel.Font.Name := 'Verdana';
   Painel.AlignWithMargins := false;
   Painel.Margins.Left := 0;
   Painel.Margins.Right := 0;
   Painel.ShowCaption := false;
end;
// *****************************************************************************
constructor TmtMenuLateral.Create(AOwner: TComponent);
begin
   inherited;
   FAtivo            := False;
   FCor              := clSkyBlue;
   FLarguraExpandida := LARGURA_EXPANDIDA;
   FMenus := TmtMenus.Create(Self);

   FTimer := TTimer.Create(Self);
   FTimer.Enabled  := false;
   FTimer.Interval := INTERVALO;
   FTimer.OnTimer  := FechaMenu;
end;
// *****************************************************************************
procedure TmtMenuLateral.CriarBotoes(Pn: TPanel; pai: String);
var i: Integer;
    Botao: TSpeedButton;
begin
   for i := FMenus.Count-1 downto 0 do begin
      if FMenus.Menu[i].Pai = pai then begin
         Botao := TSpeedButton.Create(Pn);
         Botao.Parent  := Pn;

         Botao.Align   := alTop;
         Botao.Height  := ALTURA_BOTAO;
         Botao.Flat    := True;
         Botao.Margin  := 2;
         Botao.Name    := FMenus.Menu[i].Nome;
         Botao.Caption := FMenus.Menu[i].Caption;
         if FileExists( FPathImg + FMenus.Menu[i].Imagem ) then begin
            Botao.Glyph.LoadFromFile(FPathImg + FMenus.Menu[i].Imagem);
         end;
         Botao.OnClick := FMenus.Menu[i].Procedimento;

         Botao.OnMouseEnter := EntrarNoComponente;
         Botao.OnMouseLeave := SairDoComponente;

         if Pn.Name <> 'FPainelMenu' then begin
            Pn.Height := ALTURA_BOTAO * Pn.ControlCount
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
   FPainelMenu.Height  := TWinControl( Owner ).ClientHeight;
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
      PainelFilho.Name   := NomePainel;
      PainelFilho.Top    := Botao.Top;
      PainelFilho.Left   := ( FPainelMenu.Width - ( LARGURA_CONTRAIDA+4) ) * xMenu.Nivel;
      PainelFilho.Width  := FPainelMenu.Width;
      PainelFilho.Height := 150;
      ConfiguraMenu(PainelFilho);
      PainelFilho.Parent := TWinControl( FPainelMenu.Owner );

      CriarBotoes(PainelFilho,xMenu.Nome);
   end;

   // Verifica Filhos...
   FLog.Add('Verificando Filhos');
   for i := 0 to PainelFilho.ComponentCount-1 do begin
      Botao := TSpeedButton( PainelFilho.Components[i] );
      FLog.Add(Botao.Name);
      xMenu := FMenus.Localizar(Botao.Name);
      if xMenu.Foco then begin
         if FMenus.ContarFilhos(xMenu.Nome) > 0 then begin
            CriarPainelFilho(Botao);
         end;
      end;
   end;
   FLog.Add('Fim da verificação dos filhos');

end;
// *****************************************************************************
destructor TmtMenuLateral.Destroy;
begin
   FTimer.Enabled := false;
   FTimer.free;
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
procedure TmtMenuLateral.DestruirPainelFilho(Botao: TSpeedButton);
var PainelFilho: TPanel;
    NomePainel: String;
    // xMenu: TmtMenu;
begin
   NomePainel := Botao.Name + '_Pn';

   PainelFilho := TPanel( Self.FindComponent(NomePainel) );
   // xMenu := FMenus.Localizar(Botao.Name);

   if PainelFilho <> NIL then begin
      PainelFilho.Free;
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
   Componente := TWinControl( Sender );
   FExecutei  := true;

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

      begin
         var i: Integer;
         FLog.Add('***');
         for i := 0 to FMenus.Count-1 do begin
            FLog.Add(FMenus.Menu[i].Nome + '|' + FMenus.Menu[i].Foco.ToString );
         end;
         FLog.Add('***');
      end;

      MovimentarMenu;
   except
      on E: Exception do begin
         FLog.Add('Erro: ' + E.Message);
      end;
   end;
end;

procedure TmtMenuLateral.FechaMenu( Sender: TObject );
begin
   if not FExecutei then begin
      FExecutei := true;
      MovimentarMenu;
   end;
   FTimer.Enabled := false;
end;

procedure TmtMenuLateral.LimparFoco;
var _i: Integer;
begin

   FPainelMenu.Tag := 0;
   {
   // Limpa Panels de Menus...
   for _i := 0 to FMenus.ComponentCount-1 do
      if FMenus.Components[_i].ClassType = TPanel then
         TPanel( FMenus.Components[_i] ).Tag := 0;
   }

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
       if FPainelMenu.Width <> FLarguraExpandida then
          FPainelMenu.Width := FLarguraExpandida;

       for i := FPainelMenu.ComponentCount -1 to 0 do begin
          if FPainelMenu.Components[i].ClassType = TSpeedButton then begin
             Botao := TSpeedButton( FPainelMenu.Components[i] );
             xMenu := FMenus.Localizar(Botao.Name);
             if not xMenu.Foco then begin
                DestruirPainelFilho( Botao );
             end else begin
                CriarPainelFilho( Botao );
             end;
          end;
       end;

   end else begin
       if FPainelMenu.Width <> LARGURA_CONTRAIDA then
          FPainelMenu.Width := LARGURA_CONTRAIDA;

       for i := FPainelMenu.ComponentCount -1 to 0 do begin
          if FPainelMenu.Components[i].ClassType = TSpeedButton then begin
             Botao := TSpeedButton( FPainelMenu.Components[i] );
             xMenu := FMenus.Localizar(Botao.Name);
             if not xMenu.Foco then begin
                DestruirPainelFilho( Botao );
             end;
          end;
       end;

   end;
end;
// *****************************************************************************
procedure TmtMenuLateral.SairDoComponente(Sender: TObject);
var MovMenu: TThread;
begin
   LimparFoco;
   FLog.Add('TmtMenuLateral.SairDoComponente:' + TComponent(Sender).Name);
   FExecutei := false;
   FTimer.Enabled := true;
   {
   MovMenu := TThread.CreateAnonymousThread(
              procedure
              begin
                 Sleep(1000);
                 if not FExecutei then begin
                    Self.MovimentarMenu;
                 end;
              end );
   MovMenu.FreeOnTerminate := true;
   MovMenu.Start;
   }
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
end.
