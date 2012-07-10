
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define ADD(_ptr, _copy, _add, _count, _size, _page) {\
	size_t _len = (_count) + (_add);\
	size_t _news = (_len + (_page)) & ~((_page)-1);\
	/*printf("add %d+%d=%d mod %d = %d\n", _count, _add, _len, _page, _news); */\
	if (_news != _size) { \
		_ptr = (__typeof(_ptr))realloc(_ptr, _news * sizeof((_ptr)[0]));\
		_size = _news;\
	}\
	memcpy((_ptr) + (_count), (_copy), (_add) * sizeof((_ptr)[0]));\
	_count = _len;\
}

typedef union vec3 {
	struct { double x,y,z; };
	double n[3];
} vec3;

typedef struct line_t {
	int dup : 1;
	vec3 a,b;
} line_t, *line_p;

double length2(vec3 * a)
{
    return fabs(a->n[0] * a->n[0] + a->n[1] * a->n[1] + a->n[2] * a->n[2]);
}
vec3 sub(vec3 * a, vec3 * b)
{
	vec3 res = {
		.x = b->x - a->x,
		.y = b->y - a->y,
		.z = b->z - a->z,
	};
	return res;
}
double distance2(vec3 * a, vec3 * b)
{
	vec3 s = sub(a, b);
	return length2(&s);
}

int nearlyequal(line_p s1, line_p s2)
{
	const double tolerance = 0.01 * 0.01;
	
	double aa = distance2(&s1->a, &s2->a);
	double bb = distance2(&s1->b, &s2->b);
	double ab = distance2(&s1->a, &s2->b);
	double ba = distance2(&s1->b, &s2->a);
	
	if ((aa <= tolerance && bb <= tolerance) || 
			(ab <= tolerance && ba <= tolerance))
			return 1;
	return 0;
}


int process(FILE * f)
{
	int state = 0;
	int key = 0;
	
	line_p	lines = NULL;
	int		linecount = 0, linesize = 0;
	
	int linev = 0;
	line_t current;
	
	while (!feof(f)) {
		char line[128];
		fgets(line, sizeof(line), f);
		
		char * src = line;
		while (*src <= ' ') src++;
		while (strlen(src) && src[strlen(src)-1] <= ' ')
			src[strlen(src)-1] = 0;
		
		if (state == 0) {
			sscanf(src, "%d", &key);
			state = 1;
			continue;
		}
		state = 0;
		switch (key) {
			case 0:	{ // SECTION or LINE or ENDSEC or EOF
				if (linev) {
					linev = 0;
					// SQUASH Z values!!
					current.a.z = current.b.z = 0;
					ADD(lines, &current, 1, linecount, linesize, 32);
				}
				line_t zero = { .a.n[0] = 0 };
				current = zero;
			}	break;
			case 2: // entities
			case 8: // Layer name
				break;
			case 10:
			case 20:
			case 30: {
				sscanf(src, "%lf", &current.a.n[(key / 10) - 1]);
				linev++;
			}	break;
			case 11:
			case 21:
			case 31: {
				sscanf(src, "%lf", &current.b.n[(key / 10) - 1]);
				linev++;
			}	break;
		}
	}
	printf("Read %d lines\n", linecount);
	
	for (int li = 0; li < linecount; li++) {
		for (int si = 0; si < linecount; si++) if (si != li) {
			if (nearlyequal(&lines[li], &lines[si]))
				lines[li].dup = 1;
		}
	}
	
	for (int li = 0; li < linecount; li++) {
		printf("[%3d] = %.4lf, %.4lf, %.4lf = %.4lf, %.4lf, %.4lf %s\n",
			li, lines[li].a.x, lines[li].a.y, lines[li].a.z,
			lines[li].b.x, lines[li].b.y, lines[li].b.z,
			lines[li].dup ? "DUP!!" : "");
	}
	free(lines);
	return 0;
}

int main(int argc, const char *argv[])
{
	for (int ai = 1; ai < argc; ai++) {
		FILE *f = fopen(argv[ai], "r");
		if (!f) perror(argv[ai]);
		else process(f);
		fclose(f);
	}

}
