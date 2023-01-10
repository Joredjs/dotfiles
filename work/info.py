import os
import json
import re
import urllib.parse


def createDirs(my_path):
	if not os.path.exists(my_path):
		print("La carpeta %s no existe, se va a crear" % my_path)
		os.mkdir(my_path)
		print("La carpeta %s se ha creado correctamente" % my_path)


def reposAzure(my_repo, my_path):
	#Validar si está logueado en azure
	try:
		account = json.loads(os.popen('az account show 2>&1').read())
		usuario = account["user"]
		nombre = usuario["name"]
		print(f"Conectado a Azure como: %s" % nombre)
	except:
		print("Estás logeuado? Recuerda que te puedes loguear ejecutando (az login)")
		return

	#Validar si la extension está logueada
	ext = os.popen(
		"az extension list --query [?name==`azure-devops`].name -o tsv").read()
	if not ext:
		print("Debes instalar la extensión de azure devops (az extension add --name 'azure-devops')")
		return

	try:
		if my_repo.get("organizations"):
			for org in my_repo.get("organizations"):
				print("Obteniedo los proyectos de %s" % org.get("name"))
				org_url = org.get("url")
				if org["proyectos"]:
					for proy in org["proyectos"]:
						if proy.get("download"):
							proy_cmd = "az devops project list"
							proy_org = " --organization " + org_url
							proy_q = " --query value[?id==`" + \
								proy.get("id")+"`].{id:id,name:name,url:url} "
							proyectos = json.loads(os.popen(proy_cmd+proy_org+proy_q).read())
							if proyectos:
								for az_proy in proyectos:
									repo_cmd = "az repos list"
									repo_org = " --organization " + org_url
									repo_proy = " --project " + az_proy.get("id")
									repos = json.loads(os.popen(repo_cmd+repo_org+repo_proy).read())
									if repos:
										for az_repo in repos:
											repo_path = my_path+"/"+urllib.parse.quote(az_repo.get("name"))
											if az_repo.get("webUrl") and not os.path.exists(repo_path):
												print("Se clonara el repo en la carpeta %s" % repo_path)
												os.system("git clone " + az_repo.get("webUrl")+" "+repo_path)
		else:
			print("No hay organizaciones para tu proyecto de azure")
	except:
		print("Ha courrido un error al intentar clonar los proyectos")


def reposGitlab(my_repo, my_path):
	try:
		for glab_repo in my_repo:
			repo_path = my_path+"/"+urllib.parse.quote(glab_repo.get("name"))
			if glab_repo.get("download") and glab_repo.get("url") and not os.path.exists(repo_path):
				print("Se clonara el repo en la carpeta %s" % repo_path)
				os.system("git clone " + glab_repo.get("url")+" "+repo_path)
	except:
		print("Estás logeuado? Recuerda que te puedes loguear ejecutando (glab auth login)")
		return


info = json.load(open("info.json"))
work_path = os.environ["MY_WORK"]
work = info.get('work')

if work and work_path:
	createDirs(work_path)
	if work.get('companies'):
		for comp in work.get('companies'):
			comp_path = work_path+"/"+comp["name"]
			createDirs(comp_path)
			if comp.get('clients'):
				for cli in comp["clients"]:
					cli_path = comp_path+"/"+cli["name"]
					createDirs(cli_path)
					if cli.get('repos').get("azure"):
						reposAzure(cli.get('repos').get("azure"), cli_path)
					if cli.get('repos').get("gitlab"):
						reposGitlab(cli.get('repos').get("gitlab"), cli_path)
			else:
				print("No existen clientes configurados para %s" % (comp["name"]))
	else:
		print("No existen compañias configuradas")
else:
	print("La propiedad work no existe")
