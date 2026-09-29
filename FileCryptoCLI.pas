program FileCryptoCLI;

uses
  SysUtils;

type
  TFileRecord = record
    Name: String;
    Size: Int64;
    Extension: String;
  end;

  PFileNode = ^TFileNode;
  TFileNode = record
    Data: TFileRecord;
    Next: PFileNode;
  end;

procedure AddFileNode(var Head: PFileNode; const AName, AExt: String; ASize: Int64);
var
  NewNode: PFileNode;
begin
  New(NewNode); 
  NewNode^.Data.Name := AName;
  NewNode^.Data.Extension := AExt;
  NewNode^.Data.Size := ASize;
  NewNode^.Next := Head;
  Head := NewNode;
end;

procedure PrintFileList(Head: PFileNode);
var
  Current: PFileNode;
  Index: Integer;
begin
  Current := Head;
  Index := 1;
  Writeln(sLineBreak + '--- LISTA DE ARQUIVOS GERENCIADOS ---');
  if Current = nil then
  begin
    Writeln('Nenhum arquivo registrado na memória.');
    Exit;
  end;

  while Current <> nil do
  begin
    Writeln(Format('[%d] Nome: %s | Ext: %s | Tamanho: %d bytes', 
      [Index, Current^.Data.Name, Current^.Data.Extension, Current^.Data.Size]));
    Current := Current^.Next;
    Inc(Index);
  end;
  Writeln('-------------------------------------');
end;

procedure FreeFileList(var Head: PFileNode);
var
  Current, Temp: PFileNode;
begin
  Current := Head;
  while Current <> nil do
  begin
    Temp := Current;
    Current := Current^.Next;
    Dispose(Temp); 
  end;
  Head := nil;
end;

procedure EncryptDecryptFile(const SrcFile, DstFile: string; Key: Byte);
var
  FIn, FOut: File of Byte;
  Buffer: Byte;
  BytesRead: Integer;
begin
  if not FileExists(SrcFile) then
  begin
    Writeln('Erro: Arquivo de origem não encontrado: ', SrcFile);
    Exit;
  end;

  AssignFile(FIn, SrcFile);
  Reset(FIn);

  AssignFile(FOut, DstFile);
  Rewrite(FOut);

  try
    while not Eof(FIn) do
    begin
      BlockRead(FIn, Buffer, 1, BytesRead);
      if BytesRead > 0 then
      begin
        Buffer := Buffer xor Key; 
        BlockWrite(FOut, Buffer, 1);
      end;
    end;
    Writeln('Sucesso! Arquivo processado e salvo em: ', DstFile);
  finally
    CloseFile(FIn);
    CloseFile(FOut);
  end;
end;

procedure ShowMenu;
begin
  Writeln(sLineBreak + '=== PASCAL FILE MANAGER & CRYPTO CLI ===');
  Writeln('1. Registrar metadados de arquivo na Lista Ligada');
  Writeln('2. Listar arquivos registrados na memória');
  Writeln('3. Criptografar / Descriptografar arquivo (XOR)');
  Writeln('4. Sair');
  Write('Selecione uma opcao: ');
end;

var
  Head: PFileNode;
  Choice: Integer;
  FileName, Ext, OutName: String;
  FileSize: Int64;
  KeyInput: Integer;
begin
  Head := nil;
  repeat
    ShowMenu;
    Readln(Choice);
    case Choice of
      1:
        begin
          Write('Informe o nome do arquivo: ');
          Readln(FileName);
          Write('Informe a extensao (ex: .txt): ');
          Readln(Ext);
          Write('Informe o tamanho em bytes: ');
          Readln(FileSize);
          AddFileNode(Head, FileName, Ext, FileSize);
          Writeln('-> Metadados adicionados com sucesso.');
        end;
      2:
        PrintFileList(Head);
      3:
        begin
          Write('Caminho do arquivo de origem: ');
          Readln(FileName);
          Write('Caminho do arquivo de destino: ');
          Readln(OutName);
          Write('Chave XOR (inteiro de 0 a 255): ');
          Readln(KeyInput);
          EncryptDecryptFile(FileName, OutName, Byte(KeyInput));
        end;
      4:
        Writeln('Encerrando o utilitário...');
      else
        Writeln('Opcao invalida. Tente novamente.');
    end;
  until Choice = 4;

  FreeFileList(Head);
end.
