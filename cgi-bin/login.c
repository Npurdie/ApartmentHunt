#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char * getNextLine(FILE* file, char *line, int length)
{
	char *retval = fgets(line, length, file);
	if (retval != NULL && line[strlen(line)-1] == '\n')
	{
		line[strlen(line)-1] = 0;		
	}
	return retval;
}


int main()
{
	int userFound = 0;		//boolean
	char user[20];
	char password[20];
	char scanName[20];
	char scanPassword[20];
	char scanUserName[20];

	//scan in the login username and password
	char Buffer[200];
	int inputLen = atoi(getenv("CONTENT_LENGTH"));
	fread(Buffer, inputLen, 1, stdin);
	Buffer[inputLen] = 0;

	int i = 0;
	char *pbuff = &Buffer[0];
	while(*pbuff++ != '=');

	//increment until the ampersand is reached ie. this is the username
	char *puser = &user[0];	
	while(*pbuff != '&')
	{
		*puser++ = *pbuff++;
	}
	*puser = 0;

	//increment until password
	while(*pbuff++ != '=');
	strcpy(password, pbuff);
	

	//parse members file until username is found and match password
	FILE *file = NULL;
	file = fopen("members.csv", "rt");
	char line[200];
	int numitems = 0;

	while (getNextLine(file, line, sizeof(line)) != NULL)
	{
		numitems = sscanf(line, "%s %s %s", scanName, scanUserName, scanPassword);
		if (numitems == 3 && strcmp(scanUserName, user) == 0 && strcmp(scanPassword, password) == 0)
		{
			userFound = 1;
			break;
		}
	}
	fclose(file);



	printf("Content-Type:text/html\n\n");
	if (userFound)
	{
		printf("<html>\n");
		printf("<head>\n");
		printf("<img src=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/logo.png\" width=\"50\" height=\"50\" alt=\"House Logo\">");
		printf("<title>Sucessful login!</title>\n");
		printf("</head>\n");
		printf("<body style =\"background-color:black\">\n");
		printf("<h2><font color=\"#FFFFFF\">Sucessful login!</font></h2>\n");
		printf("<form action = \"MyFacebookPage.py\" method=\"POST\">\n");
		printf("<input type=\"hidden\" name=\"username\" value=\"%s\">\n",user);
		printf("<input type=\"hidden\" name=\"action\" value=\"init\">");
		printf("<input type=\"submit\" value=\"Go to Topics Page\">");
		printf("</form>\n");
		printf("<p><small><font color=\"#808080\"> &copy Coco&SkushLtd</font></small></p>");
		printf("</body>\n");
		printf("</html>\n");
	}
	else
	{
		printf("<html>\n");
		printf("<head>\n");
		printf("<img src=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/logo.png\" width=\"50\" height=\"50\" alt=\"House Logo\">");
		printf("<title>No user found</title>\n");
		printf("</head>\n");
		printf("<body style =\"background-color:black\">\n");
		printf("<h2><font color=\"#FFFFFF\">User not found!</font></h2>\n");
		printf("<p><a href=\"http://cgi.cs.mcgill.ca/~hpurdi/ApartmentHunt/welcome.html\"> Go back to home page </a></p>\n");
		printf("<p><small><font color=\"#808080\"> &copy Coco&SkushLtd</font></small></p>");
		printf("</body>\n");
		printf("</html>\n");
	}
	return 0;
}
