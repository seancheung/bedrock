# bedrock

Minecraft bedrock server docker image

## Start server

``` bash
docker run -d -it --name bedrock -p 19132:19132/udp --restart unless-stopped -v /var/opt/bedrock:/data seancheung/bedrock
```

Latest version of official bedrock server will be download at first launch

## Configuration

Config files and world files will be written to the linked `/data` directory.

## Commands

Attach to the running container

> The container must have been started with `-it` options

```bash
docker attach bedrock
```

Type in `help` to check available commands.

Type `^P,^Q`(Ctrl+P,Ctrl+Q) to detach.

## Upgrade

Simply recreate the container. Or follow this:

```bash
docker exec bedrock rm -f /var/bedrock/.version
docker restart bedrock
```