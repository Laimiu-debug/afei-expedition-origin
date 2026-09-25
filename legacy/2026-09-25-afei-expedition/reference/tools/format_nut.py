"""Insert statement boundaries after blocks without altering quoted text/comments."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
for p in (ROOT/'src').rglob('*.nut'):
 if p.name=='definitions.nut':continue
 s=p.read_text(encoding='utf-8');out=[];state='code';escape=False;i=0
 while i<len(s):
  c=s[i];n=s[i+1:i+2];out.append(c)
  if state=='string':
   if escape:escape=False
   elif c=='\\':escape=True
   elif c=='"':state='code'
  elif state=='line':
   if c=='\n':state='code'
  elif state=='block':
   if c=='*' and n=='/':out.append(n);i+=1;state='code'
  elif c=='"':state='string'
  elif c=='/' and n=='/':out.append(n);i+=1;state='line'
  elif c=='/' and n=='*':out.append(n);i+=1;state='block'
  elif c=='}' and n not in ('','\n','\r',',',';',')',']'):
   out.append('\n')
  i+=1
 p.write_text(''.join(out),encoding='utf-8')
print('Squirrel block boundaries normalized')
