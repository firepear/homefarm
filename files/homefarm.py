# the Homefarm python utility module

import hashlib
import xml.etree.ElementTree as ET


#----------------------------------------------------------- BOINC XMLRPC funcs
def auth_conn(s, key):
    """Auth to a running BOINC instance on the provided socket, 's', with
    the provided boinc_gui_key, 'key'.

    Once this function completes successfully, 's' will be fully
    authed and ready to handle requests.
    """
    s.sendall(b'<auth1/>\003') # send the initial authorization request
    # get the reply, stringify it from bytes, strip the trailing
    # ETX, and turn that into a tree
    reply = ET.fromstring(s.recv(1024).decode('utf-8').strip('\003'))
    # hash the nonce contained in the reply with our password
    m = hashlib.md5()
    m.update(bytearray(reply[0].text, 'utf-8'))
    m.update(bytearray(key, 'utf-8'))
    nonce_hash = m.hexdigest()
    # then send it
    req = "<auth2><nonce_hash>" + nonce_hash + "</nonce_hash></auth2>\003"
    s.sendall(req.encode('utf-8'))
    # repeat the receive-and-decode dance. check answer.
    reply = ET.fromstring(s.recv(1024).decode('utf-8').strip('\003'))
    if reply[0].tag == "authorized":
        return True
    else:
        return False

def recv_msg(s):
    """Assemble a BOINC RPC response and convert to a UTF8 string"""
    chunks = []
    msgend = False
    while not msgend:
        # try to read 4kB
        chunk = s.recv(4096)
        if chunk == b'':
            raise RuntimeError("socket connection broken")
        if chunk[-1] == 3:
            # messages terminate with \003
            msgend = True
        chunks.append(chunk)
    return b''.join(chunks).decode('utf-8').strip('\003')


#------------------------------------------------------------- Formatting funcs
def strtime(time):
    """Takes a number of seconds; returns a formatted duration string"""
    years, days, hours, mins = 0, 0, 0, 0
    timestr = ""
    if time > 31536000:
        years = int(time / 31536000)
        time = time - (31536000 * years)
    if time > 86400:
        days = int(time / 86400)
        time = time - (86400 * days)
    if time > 3600:
        hours = int(time / 3600)
        time = time - (3600 * hours)
    if time > 60:
        mins = int(time / 60)
        time = time - (60 * mins)
    if years > 0:
        return "{}y {}d {:02d}h {:02d}min {:02d}s".format(years, days, hours, mins, int(time))
    if days > 0:
        return "{}d {:02d}h {:02d}min {:02d}s".format(days, hours, mins, int(time))
    return "{:02d}h {:02d}min {:02d}s".format(hours, mins, int(time))

