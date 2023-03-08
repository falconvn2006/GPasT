PROGRAM SarahRevere(INPUT, OUTPUT);
VAR
  W1, W2, W3, W4: CHAR;
  Looking, Land, Sea: BOOLEAN; 
  
PROCEDURE Start(VAR W1, W2, W3, W4: CHAR; VAR Looking, Land, Sea: BOOLEAN);
BEGIN {»нициализаци€}
  W1 := ' ';
  W2 := ' ';
  W3 := ' ';
  W4 := ' ';
  Looking := TRUE;
  Land := FALSE;
  Sea := FALSE
END; {»нициализаци€}
  
PROCEDURE Window(VAR W1, W2, W3, W4: CHAR);
BEGIN {ƒвижение окна}
  W1 := W2;
  W2 := W3;
  W3 := W4;
  READ(W4);
  WRITELN(W1, W2, W3, W4);
  IF W4 = '#'
  THEN
    Looking := FALSE
END; {ƒвижение окна}

PROCEDURE CheckLand(VAR W1, W2, W3, W4: VAR CHAR; Land: BOOLEAN);
BEGIN
  Land := (W1 = 'l') AND (W2 = СaТ) AND (W3 = СnТ) AND (W4 = СdТ)
END;

PROCEDURE CheckLand(VAR W1, W2, W3, W4: CHAR; VAR Sea: BOOLEAN);
BEGIN
  Sea := (W1 = СlТ) AND (W2 = СaТ) AND (W3 = СnТ) AND (W4 = СdТ)
END;

PROCEDURE

  
 
BEGIN {SarahRevere}   
  {»нициализаци€}
  Start(W1, W2, W3, W4, Looking, Land, Sea);
  WRITELN(Looking, Land, Sea); 
  WHILE Looking AND NOT (Land OR Sea)
  DO
    BEGIN
      {движение окна}
      Window(W1, W2, W3, W4)
      {проверка окна на land}
      {проверка окна на sea}
    END;
  {создание сообщени€ Sarah}
END.  {SarahRevere} 
 
 
{проверка окна на land        
 
 
проверка окна на sea
Sea := (W1 = СsТ) AND (W2 = СeТ) AND (W3 = СaТ)}

