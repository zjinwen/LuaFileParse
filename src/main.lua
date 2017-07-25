local fileOpen = io.open("E:\\zh\\test", "r");
local data = fileOpen:read("*a"); -- 读取所有内容
fileOpen:close();


local function parseFile(data,fileModel)
      fileModel.fileData ={};
      local  itr=string.gmatch(data,"(.-)\n");
      for w in itr do
             setFileName(w,fileModel);
             if string.len(w)==0 then
                if fileModel.boundary ==nil then
                  print("header over");
                  break;
                else
                  itr();
                  local  boundary= itr();
                  if boundary~="--"..fileModel.boundary then 
                     print ("error---");
                     print (boundary);
                     print (fileModel.boundary);
                     return false;
                  end;
                  local  disposition= itr();
                  local nameFileFun= string.gmatch(disposition,"(%w+)=\"(.-)\"");
                  for nk2,nn2 in nameFileFun  do
                    if nk2=="filename" then
                        fileModel.filename=nn2;
                        if saveFileData(itr,fileModel) ~=nil then return true; end;
                    end
                  end
                  
                end
             end
      end
end
function saveFileData(itr,fileModel)
               local cfd=-1;
                for entity in itr  do 
                      if cfd==-1  then  if string.len(entity)==0 then cfd=1; end--start file
                      else  
                            local  fbound,_=string.find(entity,"--"..fileModel.boundary)
                            if fbound==1 then  
                              fileModel.lineCount=cfd-1;
                              return   fileModel;         
                            end
                            fileModel.fileData[cfd]=entity.."\n";
                            cfd=cfd+1;
                      end;
               end
            return nil;
  end
                      
function setFileName(w,fileModel)
  for k, v in string.gmatch(w, "(.+):%s(.+)") do
                 if k=='Content-Type'  then
                  local  findex,_=string.find(v,"multipart%/form%-data;")
                    if(findex==1)then
                         fileModel.boundary=string.gmatch(v,"; boundary=(.+)")();
                         return true;
                    end
                 end
  end
  return false;
end



local fileModel={};
if(parseFile(data,fileModel)) then
local x=1;
while x <= fileModel.lineCount do
 print (fileModel.fileData[x])
 x=x+1
end
 end

