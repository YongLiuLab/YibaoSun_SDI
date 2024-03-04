import pathlib
import os
import subprocess

class plotSurfIce:
    def __init__(self, inputPath, outputPath) -> None:
        self.inputPath = r'F:\Code\coupling\data\surfIce\temp\nii'
        self.outputfig = r'F:\Code\coupling\data\surfIce\temp\output'
        self.pathSurfEXE = r'D:\User\Desktop\surfice_windows\Surf_Ice\surfice.exe '
        self.scriptTEMP = r'F:\Code\coupling\data\surfIce\temp\script'

        self.pathsurf = r'F:\Code\coupling\data\surfIce\temp\surf'

    def defaultScript(self):
        self.ScriptCode = ["import gl",
                           "gl.resetdefaults()",
                           "gl.meshload('BrainMesh_ICBM152.mz3')",
                           "",
                           "",
                           "",

                           ]
        
    def loadScript(self, scriptPath):
        f=open(scriptPath, encoding='gbk')
        self.codes = f.readlines()
        print(self.codes)

    def run(self):
        self.changePath()

    def runCode(self):
        fileName = pathlib.Path(self.scriptTEMP) / (self.tempName + '.py')
        
        with open(fileName,"w") as f:
            f.writelines(self.codeTemp)

        cmd_str = self.pathSurfEXE + str(fileName)
        
        subprocess.Popen(cmd_str)
        os.system("taskkill /F /IM " + self.pathSurfEXE)
        
        
    def changePath(self):
        codes = self.codes
        P_input = pathlib.Path(self.inputPath)
        P_surf = pathlib.Path(self.pathsurf)
        
        for i in range(len(codes)):
            if codes[i].find('overlayload') != -1:
                for file_name in P_input.glob('*.nii*'):
                    codes[i] = "gl.overlayload(r'" + str(file_name) + "')\n"

                    for j in range(len(codes)):
                        if codes[j].find('gl.azimuthelevation') != -1:
                            for angle in [90,270]:
                                codes[j] = "gl.azimuthelevation(" + str(angle) + ",0)\n"

                                for k in range(len(codes)):
                                    if codes[k].find('meshload') != -1:
                                        for surf_name in P_surf.glob('*.mz3'):
                                            codes[k] = "gl.meshload(r'" + str(surf_name) + "')\n"
                                            
                                            for l in range(len(codes)):
                                                if codes[l].find('savebmp') != -1:
                                                    savefigPath = pathlib.Path(self.outputfig) / (str(surf_name.stem) + str(file_name.stem)+ str(angle)+'.png')
                                                    
                                                    codes[l] = "gl.savebmp(r'" + str(savefigPath) + "')\n"
                                                    self.codeTemp = codes
                                                    self.tempName = (str(surf_name.stem) + str(file_name.stem)+ str(angle))

                                                    print(codes)
                                                    
                                                    self.runCode()

                                            
a = plotSurfIce('','')
a.loadScript(r'F:\Code\coupling\data\surfIce\temp\sample.py')
a.run()

