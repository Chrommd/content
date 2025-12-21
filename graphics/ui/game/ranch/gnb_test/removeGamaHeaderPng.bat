@echo off

for %%f in (gnb_btn*.png) do (
    echo Processing %%f ...
    magick "%%f" +set gamma "%%f"
)

echo Done!
pause