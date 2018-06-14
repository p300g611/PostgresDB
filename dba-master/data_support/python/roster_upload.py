#!/usr/bin/python
import requests
import sys
import logging

from requests.auth import HTTPBasicAuth
from bs4 import BeautifulSoup
from datetime import datetime
from pytz import timezone

#logging
LOG_FILENAME = 'upload.log'
logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)

# session
with requests.Session() as s:
    # get csrf token for logIn using beautifulsoup
    login_url = "https://educator.fix.cete.us/AART/logIn.htm"
    r = s.get(login_url)
    soup2 = BeautifulSoup(r.text,"html.parser")
    desc= soup2.find(attrs={'name':'_csrf'})
    logging.debug("desc is %s",desc)
    x_scrf_token = desc['content']
    logging.debug("X-CSRF token value is  %s" ,x_scrf_token)

# authentication
    auth_url = "https://educator.fix.cete.us/AART/j_spring_security_check"

    auth_headers ={
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding":"gzip, deflate",
        "Accept-Language":"en-US,en;q=0.8",
        "Cache-Control":"max-age=0",
        "Connection":"keep-alive",
        "Host":"educator.fix.cete.us",
        "Origin":"https://educator.fix.cete.us",
        "Referer":"https://educator.fix.cete.us/AART/userHome.htm",
        "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:43.0) Gecko/20100101 Firefox/43.0",
        "X-Requested-With":"XMLHttpRequest",
        "X-CSRF-TOKEN":x_scrf_token
        }

    try:
        logging.debug("Accessing Login page ")

        login_data= dict(j_username='your_username@gmail.com',
                    j_password='your_password',
                    _csrf=x_scrf_token)

        response=s.post(auth_url,data=login_data,headers=auth_headers)
        logging.debug("response headers are %s" ,response.headers)
        logging.debug("Successful login")
        #logging.debug(response.content)
        logging.debug(response.status_code)
        response.raise_for_status()

    except requests.exceptions.HTTPError  as e:
        print ("And you get an HTTPError:", e.message)
    #cookies
    """
    session_cookie - cookie received from the session object
    """
    session_cookie = s.cookies.get_dict()

    """
    param_cookie - cookie sent as a parameter to the file upload service
    """
    param_cookie = 'JSESSIONID'+ "="+session_cookie['JSESSIONID']
    logging.debug(param_cookie)

    # extract csrf token for uploadEnrollment
    url = "https://educator.fix.cete.us/AART/getabUploadProgressStatus.htm?&categoryCode=ENRL_RECORD_TYPE"
    r1 = s.post(url,headers=auth_headers)
    soup3 = BeautifulSoup(r1.text,"html.parser")
    #logging.debug("soup3 is %s",soup3)
    desc3= soup3.find(attrs={'name':'_csrf'})
    logging.debug("desc3 is %s",desc3)
    x_scrf_token2 = desc3['content']
    logging.debug("X-CSRF token2 value is  %s" ,x_scrf_token2)


    session_cookie2 = s.cookies.get_dict()
    param_cookie2 = 'JSESSIONID'+ "="+session_cookie2['JSESSIONID']
    logging.debug("cookie for upload enrollment is %s",param_cookie2)

    #file uploading
    logging.debug("File Uploading Started")
    upload_url ="https://educator.fix.cete.us/AART/uploadFileData.htm"
    logging.debug("Accessing file")
    filename ="Roster_Template01.csv"
    logging.debug("Ready to upload file")
    dateobject = datetime.now(timezone('US/Central')).strftime("%a %b %d %Y %H:%M:%S %Z%z")
    logging.debug("date is %s",dateobject)
    millisecobject = (datetime.now().microsecond)/1000
    logging.debug("millisec is %s",millisecobject)

    files = {
            'stateId':('','9592'),
            'districtId':('','32203'),
            'schoolId':('','32732'),
            'selectedOrgId':('','32732'),
            'categoryCode':('','SCRS_RECORD_TYPE'),
            'reportUpload':('','false'),
            'date':('',dateobject),
            'milliSec':('',str(millisecobject)),
            'uploadFile':(filename,open(filename,'rb'),'text/csv',{'Expires': '0'})
            #'uploadFile':filename
            }


    logging.debug("files dictionary is %s",files)
    upload_headers = {
                "Accept":"application/json, text/javascript, */*; q=0.01",
                "Accept-Encoding":"gzip, deflate",
                "Accept-Language":"en-US,en;q=0.5",
                #"Content-Type":"multipart/form-data",
                #"Cookie":param_cookie2,
                "Host":"educator.fix.cete.us",
                #Origin":"https://educator.fix.cete.us",
                "Referer":"https://educator.fix.cete.us/AART/configuration.htm",
                "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:43.0) Gecko/20100101 Firefox/43.0",
                "X-Requested-With":"XMLHttpRequest",
                #"X-CSRF-TOKEN":x_scrf_token2
                }
    upload_headers["Cookie"] = param_cookie2
    upload_headers["X-CSRF-TOKEN"] = x_scrf_token2

    #logging.debug("cookie for upload enrollment is %s",upload_headers["Cookie"])
    logging.debug("x-csrf-token for upload enrollment is %s",upload_headers["X-CSRF-TOKEN"])

    try:
        logging.debug("before file upload request")
        resp = s.post(upload_url,files=files,headers=upload_headers)
    except requests.exceptions.HTTPError  as e:
        print ("And you get an HTTPError:", e.message)

    #resp = s.post(upload_url,data=upload_data,headers=upload_headers)
    logging.debug("after file upload request")
    logging.debug(resp.text)
    logging.debug(resp.status_code)

    try:
        resp.raise_for_status()
        
    except requests.exceptions.HTTPError  as e:
        print ("And you get an HTTPError:", e.message)
