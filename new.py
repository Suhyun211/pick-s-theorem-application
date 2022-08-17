from tkinter import *

from itertools import product
from numpy import polyfit
from random import randint

# poly = [ (randint(-7,12), randint(-7,12)) for i in range(randint(3, 10)) ]
# poly += [poly[0]]

# def c_to_canvas(a):
#     return (a + 7) * 25

# def create_interface():
#     root = Tk()
#     root.geometry("500x520")
#     canvas = Canvas(root, bg='white')
#     message = StringVar(root)
#     entry = Entry(root, textvariable=message)
#     canvas.pack(expand=1, fill=BOTH)
#     entry.pack(side=BOTTOM)
    
    
#     for i in range(20):
#         x, y = i*25, i*25
#         canvas.create_line(0, y, 500, y, fill='gray')
#         canvas.create_line(x, 0, x, 500, fill='gray')
        
#     for x, y in poly:
#         x1, y1, x2, y2 = [ c_to_canvas(x) for x in [x-0.1, y-0.1, x+0.1, y+0.1] ]
#         canvas.create_oval(x1, y1, x2, y2)

#     for a, b in [ poly[i:i+2] for i in range(len(poly)-1) ]:
#         x1, y1, x2, y2 = [ c_to_canvas(x) for x in a + b ]
#         canvas.create_line(x1, y1, x2, y2, fill='blue', width=2)
    
#     root.bind('<Escape>', lambda x: root.destroy())
#     return root, canvas, message

# def draw_points(canvas, A_points, B_points):
#     for x, y in B_points:
#         x1, y1, x2, y2 = [ c_to_canvas(x) for x in [x-0.1, y-0.1, x+0.1, y+0.1] ]
#         canvas.create_oval(x1, y1, x2, y2, fill='green')
#     for x, y in A_points:
#         x1, y1, x2, y2 = [ c_to_canvas(x) for x in [x-0.1, y-0.1, x+0.1, y+0.1] ]
#         canvas.create_oval(x1, y1, x2, y2, fill='red')

def point_in_poly(p, poly):
    x, y = p
    odd = False
    
    for segment_a, segment_b in zip(poly, poly[1:] + [poly[0]]):
        x_a, y_a = segment_a
        x_b, y_b = segment_b
        if (y_a < y <= y_b) or (y_b < y <= y_a):
            if (x_a + (y - y_a) / (y_b - y_a) * (x_b - x_a)) < x:
                odd = not odd
    
    return odd

def find_A_points(poly, B_points):
    min_x, max_x = min([x[0] for x in poly ]), max([x[0] for x in poly ])
    min_y, max_y = min([x[1] for x in poly ]), max([x[1] for x in poly ])
    all_points = set(product(range(min_x+1, max_x), range(min_y+1, max_y))) - B_points
    return set([point for point in all_points if point_in_poly(point, poly)])

def find_B_points(poly):
    def f(k, x ,b):
        return round(k * x + b,2)

    B_points = set(poly)

    for segment in [ poly[i:i+2] for i in range(len(poly)-1) ]:
        X = [x[0] for x in segment ]
        Y = [x[1] for x in segment ]
        min_x, max_x = min(X), max(X)
        try:
            assert min_x != max_x, 'vertical line'
            k, b = [ round(x,2) for x in polyfit(X, Y, 1) ]
            B_points |= set([ (x, f(k, x, b)) for x in range(min_x, max_x) if abs(f(k, x, b) - int(f(k, x, b))) < 0.01 ])
        except (ValueError, AssertionError):
            min_y, max_y = min(Y), max(Y)+1
            x = X[0]
            B_points |= set([ (x, y) for y in range(min_y, max_y) ])
    return B_points



# root, canvas, message = create_interface()
# draw_points(canvas, A_points, B_points)
# message.set("%s = %s + %s / 2 - 1" % (S, A, B))
# root.mainloop()