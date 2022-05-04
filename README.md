# Ombi in Docker optimized for Unraid
Ombi is a self-hosted web application that automatically gives your shared Emby/Jellyfin/Plex users the ability to request content by themselves! Ombi can be linked to multiple TV Show and Movie DVR tools to create a seamless end-to-end experience for your users. 

**Update:** The container will check on every start/restart if there is a newer version available (you can also choose between stabel and develop version - keep in mind that switching from a stable to a develop version and vice versa will/can break the container).


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /ombi |
| OMBI_REL | Enter if you want to download the latest or develop version | latest |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name Ombi -d \
	-p 5000:5000 \
	--env 'OMBI_REL=latest' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /path/to/ombi:/ombi \
	ich777/ombi
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/