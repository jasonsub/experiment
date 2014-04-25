#ifndef BCPHEAD_H
#define BCPHEAD_H

class Matrix
{
private:
	int **A;
	int *len;
	int *col;
public:
	int m,n;
	bool noSolu;
	Matrix(int,int);
	Matrix(const Matrix &);
	int read_A(int,int) const;
	~Matrix();
	int rowLen(int) const;
	int xValue(int) const;
	void assign_A(int,int,int);
	void update_len();
	void deleteRow(int);
	void setColZero(int);
	void setColOne(int);
	bool dom_R(int,int);
	bool dom_C(int,int);
};

#endif