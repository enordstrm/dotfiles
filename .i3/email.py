#!/usr/bin/env python2.7
""" This scripts checks how many emails there are in the IMAP inbox. """
import imaplib
import argparse


class Inbox(object):
    """ This is an inbox. """
    def __init__(self, server, user, password):
        self._server = server
        self._user = user
        self._password = password
        self._conn = imaplib.IMAP4_SSL(server)

    def unread(self):
        """ Get number of unread emails. """
        (retcode, messages) = self._conn.search(None, '(UNSEEN)')
        if retcode != 'OK':
            raise LookupError
        return len(messages[0].split())

    def set_all_read(self):
        """ Mark all emails as read. """
        retcode, messages = self._conn.search(None, '(UNSEEN)')
        if retcode != 'OK':
            raise LookupError
        for num in messages[0].split():
            ret, _ = self._conn.store(num, '+FLAGS', '\\Seen')
            if ret != 'OK':
                raise LookupError

    def __enter__(self):
        retcode, _ = self._conn.login(self._user, self._password)
        if retcode != 'OK':
            raise LookupError
        self._conn.select()  # Select inbox or default namespace
        return self

    def __exit__(self, exec_type, exec_value, trace_back):
        self._conn.close()


def main():
    """ Main function! """
    parser = argparse.ArgumentParser(description='imap-stuff')
    parser.add_argument('--set-seen', action='store_true',
                        help='Set Seen-flag on all messages')
    parser.add_argument('-q', action='store_true', dest='quiet',
                        help='Do not display help text (only print value)')
    parser.add_argument('-u', '--user', dest='user', help='Username')
    parser.add_argument('-p', '--password', dest='password', help='Password')
    parser.add_argument('-s', '--server', dest='server', help='Server')

    args = parser.parse_args()

    with Inbox(args.server, args.user, args.password) as inbox:
        if args.quiet:
            print inbox.unread()
        else:
            print "Unread E-Mails: ", inbox.unread()

if __name__ == "__main__":
    main()
