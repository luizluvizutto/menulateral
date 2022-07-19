# Simples Menu Lateral criado com panel e speedbutton

```  
Uses
  Un_MenuLateral,
  Un_MenuLateralDef;
...
var
  FMenuLateral: TmtMenuLateral;
...
procedure TForm1.FormCreate(Sender: TObject);
begin
   FMenuLateral := TmtMenuLateral.Create(Self);
   FMenuLateral.PathImg := ExtractFilePath( Application.ExeName ) + 'img\';
   FMenuLateral.Cor := $00F9E9DB;
   FMenuLateral.Menus.CorNivel[1]  := $00E3E3FF;
   FMenuLateral.Menus.CorNivel[2]  := $00DBFFED;
   {
   FMenuLateral.Menus.CorNivel[3]  := $00F0CAA8;
   FMenuLateral.Menus.CorNivel[4]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[5]  := $00F0CAA8;
   FMenuLateral.Menus.CorNivel[6]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[7]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[8]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[9]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[10] := $00E9AF7C;
   }

   FMenuLateral.Menus.Add('',              'MnProduto',       'Produtos',         NIL, 'produto.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdSetor',     'Setor',            NIL, 'Picture.bmp');
     FMenuLateral.Menus.Add('MnProdSetor', 'MnProdSubSetor',  'Sub-Setor',        NIL, 'Picture.bmp');

   FMenuLateral.Menus.Add('',              'MnPessoa',        'Pessoas',          NIL, 'Pessoa.bmp');
   FMenuLateral.Menus.Add('',              'MnNFe',           'Notas Fiscais',    NIL, 'NF-e.bmp');

   FMenuLateral.Menus.Add('',              'MnFinanceiro',    'Financeiro',       NIL, 'Financas.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCPag',     'Contas a Pagar',   NIL, 'CPagar.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCRec',     'Contas a Receber', NIL, 'CReceber.bmp');


   FMenuLateral.Ativo := true;
end;
```

###### Doação colaboração chave pix: 2d405f0d-ea0e-4152-bc7c-6f3a7e476b92
![MenuFechado](https://user-images.githubusercontent.com/31738097/179783116-19f93e7a-0fff-4715-b48c-6824e1961b23.png)

![MenuAberto](https://user-images.githubusercontent.com/31738097/179783470-5cced8cf-d534-456c-b848-a34aa3b1d633.png)
![MenuAberto1](https://user-images.githubusercontent.com/31738097/179783680-1cb61483-c788-4eed-8499-ddf996d208d1.png)
