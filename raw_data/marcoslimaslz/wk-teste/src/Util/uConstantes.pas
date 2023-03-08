unit uConstantes;

interface

resourcestring
  sPortInUse = '- Error: Port %s already in use';
  sPortSet = '- Port set to %s';
  sServerRunning = '- The Server is already running';
  sStartingServer = '- Starting HTTP Server on port %d';
  sStoppingServer = '- Stopping Server';
  sServerStopped = '- Server Stopped';
  sServerNotRunning = '- The Server is not running';
  sInvalidCommand = '- Error: Invalid Command';
  sIndyVersion = '- Indy Version: ';
  sActive = '- Active: ';
  sPort = '- Port: ';
  sSessionID = '- Session ID CookieName: ';
  sCommands = 'Comandos: ' + slineBreak +
    '   - "1" to start the server'+ slineBreak +
    '   - "2" to stop the server'+ slineBreak +
    '   - "99" to close the application';

Const
  cstArrow = '->';
  cstCommandStart = '1';
  cstCommandStop = '2';
  cstCommandStatus = '3';
  cstCommandHelp = '4';
  cstCommandSetPort = '5';
  cstCommandExit = '99';

implementation

end.
