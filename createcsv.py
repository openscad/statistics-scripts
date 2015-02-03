#!/usr/bin/env python

import csv
import sys

if len(sys.argv) != 3:
    print "Usage: createcsv.py <input.csv> <output.csv>"
    exit(1)

infile = sys.argv[1]
outfile = sys.argv[2]

# Read popularity database
jobreader = csv.reader(open('customizer-jobs.csv', 'rb'))
jobreader.next() # Skip header
jobdict = {int(k): int(v) for k, v in jobreader}

ifile  = open(infile, "rb")
ofile  = open(outfile, "wb")
reader = csv.reader(ifile)
writer = csv.writer(ofile, delimiter=',')

rownum = 0
for row in reader:
    # Save header row.
    if rownum == 0:
        header = row
        header.append('Improvement from 2013.06')
        header.append('Improvement from 2014.03')
        header.append('hide')
        header.append('popularity')
        writer.writerow(row)
    else:
        thingid = row[0] = int(row[0])
        oldtime = float(row[1])
        mastertime = float(row[2])
        newtime = float(row[3])
        changed = row[4] = int(row[4]) != 0
        improvement = (oldtime+0.1)/(newtime+0.1)
        row.append('{:.1f}'.format(improvement))
        row.append('{:.1f}'.format((mastertime+0.1)/(newtime+0.1)))
        row.append(not changed and
                   ((oldtime < 1 and mastertime < 1 and newtime < 1) or
                    (improvement >= 0.8 and improvement <= 1.2)))
        if thingid in jobdict: row.append(jobdict[thingid])
        else: row.append(-1)
        writer.writerow(row)
#        colnum = 0
#        for col in row:
#            print '%-8s: %s' % (header[colnum], col)
#            colnum += 1
            
    rownum += 1

ifile.close()
ofile.close()
