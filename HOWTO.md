# Trabajo Práctico Especial - Redes de Información - Infraestructura como código

Autores:

- Espina, Segundo
- Limachi, Desiree
- Rossin, Gonzalo
- Ruiz, Mateo

## Requisitos

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://www.terraform.io/downloads.html)

## Clonar repositorio

Para clonar el repositorio
utilizando ssh ejecutar:

```
git clone git@github.com:sespina99/TPRedes.git
```

utilizando https ejecutar:

```
git clone https://github.com/sespina99/TPRedes.git
```

o descargar `.zip` desde [github](https://github.com/sespina99/TPRedes)


## Obtener credenciales

Si se encuentra desde la cuenta Academy de AWS, previamente se deben setear las credenciales correspondientes de AWS en el archivo que podrá encontrar en:
Mac/Linux:
```
~/.aws/credentials
```
Windows:
```
C:\Users\username\\.aws\credentials
```

Si no utiliza la cuenta de Academy, se debe crear un usuario en AWS con permisos de administrador y obtener las credenciales de este usuario. Podrá consultar si estan correctamente configurados a partir de:
```
aws configure
```
```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_SESSION_TOKEN= 
```

### Instrucciones

Se debe disponer de un archivo de variables de extension <i>.tfvvars</i> con las variables definidas en el archivo cloud/variables.tf. Como modelo del mismo se provee el archivo cloud/terraform.example.tfvars.

Suponiendo que se cuenta con el archivo de variables en el path <i>path_variables</i>, para ejecutar el proyecto se deben realizar las siguientes instrucciones en una terminal situada en el directorio raiz del mismo:

```
$ cd cloud

$ terraform init

$ terraform plan -var-file="path_variables"

$ terraform apply -var-file="path_variables"
```


## Módulos utilizados

A continuación se presenta la lista de los módulos utilizados en el proyecto. Los mismos son <i>custom-made</i>, a menos que se especifique lo contrario:

- <b>Route 53:</b> Utilizado para generar los registros de DNS necesarios para exponer la CDN.
- <b>S3:</b> Utilizado para servir el frontend de la aplicación (bucket <i>www.</i>, <i>redes.com</i>).
- <b>CloudFront:</b> Utilizado para recibir las requests del Route 53 y servirle el frontend de la aplicación al usuario. Con esto se logra que el s3 de la website estática solo puede ser accedido desde el cloudfront.
- <b>VPC:</b> Utilizado para crear la VPC especificada en la arquitectura que contiene las capas de aplicación y base de datos del proyecto, junto con todas sus componentes (subnets, cidrs, etc).
- <b>EC2:</b> Utilizado para ejecutar las instancias del sitio web. En este proyecto, se configuran instancias EC2 en un Auto Scaling Group (ASG) para asegurar alta disponibilidad y escalabilidad automática basada en la demanda de tráfico.
- <b>Internet Gateway:</b> Utilizado para permitir que los recursos dentro de la VPC tengan acceso a internet y también puedan recibir tráfico desde internet. 
- <b>NAT Gateway:</b> Utilizado para permitir que las instancias en subnets privadas puedan acceder a internet de manera segura sin exponer sus direcciones IP privadas. 


## Diagrama de arquitectura