# nautobot codespace notes

Create your own codespace using this repo - or fork the repo if you want to make changes.

After you start nautobot, we need to run `createsuperuser` from the vscode terminal to setup a Login and Password ( in the example we used admin / admin but feel free to use whatever you prefer )



<img width="654" height="396" alt="image" src="https://github.com/user-attachments/assets/27dd4bc7-cb8c-47a7-bf9e-880de9688986" />

<img width="740" height="361" alt="image" src="https://github.com/user-attachments/assets/57a70101-c9fc-4afd-809b-6ad3ad20ea18" />

<img width="2566" height="1398" alt="image" src="https://github.com/user-attachments/assets/9d259763-4896-40b0-a67e-b7116e47c78c" />

<img width="856" height="435" alt="image" src="https://github.com/user-attachments/assets/a7dc3c5c-01ac-4f82-bd5e-061d3d971080" />


```bash
👋 Welcome to Codespaces! You are on a custom image defined in your devcontainer.json file.

🔍 To explore VS Code to its fullest, search using the Command Palette (Cmd/Ctrl + Shift + P)

📝 Edit away, then run your build command to see your code running in the browser.
@user1 ➜ /workspaces/codespaces-examples (main) $ ls -l
total 8
-rw-rw-rw- 1 vscode vscode 134 Mar 11 17:17 nautobot-only.txt
-rw-rw-rw- 1 vscode root   498 Mar 11 17:15 README.md
@user1 ➜ /workspaces/codespaces-examples (main) $ cat nautobot-only.txt
logs:/workspaces/.codespaces/.persistedshare
User=admin / Password=admin
docker exec -it nautobot-lab nautobot-server createsuperuser
@user1 ➜ /workspaces/codespaces-examples (main) $ docker exec -it nautobot-lab nautobot-server createsuperuser
Username: admin
Email address: admin@localhost.com
Password: 
Password (again): 
Superuser created successfully.
@user1 ➜ /workspaces/codespaces-examples (main) $
```
