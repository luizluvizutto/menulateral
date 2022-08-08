unit Un_Configura;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,

  Un_MenuLateral,
  Un_MenuLateralDef, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
  private
    FMenus: TmtMenus;
    procedure SetFMenus(const Value: TmtMenus);
    { Private declarations }
    procedure MontarPainel;
    procedure Limpar;
    procedure AtribuirEventos;
    procedure Clique( Sender: TObject );
  public
    property Menus: TmtMenus read FMenus write SetFMenus;
    { Public declarations }
  end;


implementation

{$R *.dfm}

{ TForm2 }

procedure TForm2.AtribuirEventos;
var i: Integer;
begin
   if Panel1 <> NIL then
      for i := Panel1.ComponentCount-1 downto 0 do
         TCheckBox( Panel1.Components[i] ).OnClick := clique;

end;

procedure TForm2.Clique(Sender: TObject);
var M: TmtMenu;

   procedure DesligarFilhos( _nome: String );
   var
     _i: Integer;
     _Chk: TCheckBox;
   begin
      for _i := 0 to FMenus.Count -1 do begin
         if FMenus.Menu[_i].Pai = _nome then begin
            _Chk := TCheckBox( Panel1.FindComponent( FMenus.Menu[_i].Nome ) );
            _Chk.Checked := false;
         end;
      end;
   end;

   procedure LigarPai( _nome: String );
   var
     _M: TmtMenu;
     _Chk: TCheckBox;
   begin
      _M := FMenus.Localizar(_nome);
      _Chk := TCheckBox( Panel1.FindComponent( _M.Nome ) );
      _Chk.Checked := true;
      if _M.Pai <> '' then begin
         LigarPai( _M.Pai );
      end;
   end;

begin
   M := FMenus.Localizar( TComponent( Sender ).Name );
   if M <> NIL then begin

      M.Visivel := not M.Visivel;

      if not M.Visivel then begin
         DesligarFilhos( M.Nome );
      end else begin
         LigarPai( M.Nome );
      end;
   end;
end;

procedure TForm2.Limpar;
var i: Integer;
begin
   if Panel1 <> NIL then begin
      for i:= Panel1.ComponentCount-1 downto 0 do
         Panel1.Components[i].Free;
   end;
end;

procedure TForm2.MontarPainel;
var
   Linha: Integer;
   chk: TCheckBox;

  procedure M( _nome: String; _l: Integer );
  var i: Integer;
  begin
     for i := 0 to FMenus.Count -1 do begin
        if FMenus.Menu[i].Pai = _nome then begin
           chk := TCheckBox.Create(Panel1);
           chk.Parent := Panel1;
           chk.top := (Linha);
           chk.Caption := FMenus.Menu[i].Caption;
           chk.Name := FMenus.Menu[i].Nome;
           chk.Left := _l + 20;

           chk.Checked := FMenus.Menu[i].Visivel;

           Linha := Linha + 25;

           M( FMenus.Menu[i].Nome, chk.Left );
        end;
     end;
  end;
begin
   Limpar;
   Linha := 1;
   M( '', 1 );
   AtribuirEventos;
end;

procedure TForm2.SetFMenus(const Value: TmtMenus);
begin
   FMenus := Value;
   MontarPainel;
end;

end.
