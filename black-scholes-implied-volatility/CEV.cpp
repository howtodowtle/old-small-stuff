double impliedVol(double spot, double mat, double strike, double price) {		//Brent's Method

	double tol = 0.000001;

	const int ITMAX = 100; 					//Maximum allowed number of iterations.
	const double EPS = std::numeric_limits<double>::epsilon();	//Machine floating-point precision.
	double a = 0.00001, b = 3, c = 3, d, e;
	double fa = BlackScholes(spot, a, mat, strike).Price() - price;
	double fb = BlackScholes(spot, b, mat, strike).Price() - price;
	double fc, p, q, r, s, xm, tol1;

	if ((fa > 0.0 && fb > 0.0) || (fa < 0.0 && fb < 0.0))
		throw("The root is not bracketed");
		//return NULL;

	fc = fb;

	for (int i = 0; i < ITMAX; ++i) {
		if ((fb > 0.0 && fc > 0.0) || (fb < 0.0 && fc < 0.0)) {
			c = a;			//Rename a, b, c and adjust bounding interval
			fc = fa;
			e = d = b - a;
		}
		if (abs(fc) < abs(fb)) {
			a = b;	fa = fb;
			b = c;	fb = fc;
			c = a;	fc = fa;
		}

		tol1 = 2.0 * EPS * abs(b) + 0.5*tol; //Convergence check.
		xm = 0.5 * (c - b);

		if (abs(xm) <= tol1 || fb == 0.0) return b;

		if (abs(e) >= tol1 && abs(fa) > abs(fb)) {
			s = fb / fa; 						//Attempt inverse quadratic interpolation.
			if (a == c) {
				p = 2.0 * xm * s;
				q = 1.0 - s;
			} else {
				q = fa / fc;
				r = fb / fc;
				p = s * (2.0 * xm * q * (q - r) - (b - a) * (r - 1.0));
				q = (q - 1.0) * (r - 1.0) * (s - 1.0);
			}
			if (p > 0.0) q = -q;
			p = abs(p);

			double min1 = 3.0 * xm * q - abs(tol1 * q);
			double min2 = abs(e * q);

			if (2.0*p < (min1 < min2 ? min1 : min2)) {
				e = d; 					//Accept interpolation.
				d = p / q;
			} else {
				d = xm; 				//Interpolation failed, use bisection.
				e = d;
			}
		} else { 					//Bounds decreasing too slowly, use bisection.
			d = xm;
			e = d;
		}

		a = b;	 					//Move last best guess to a.
		fa = fb;

		if (abs(d) > tol1) 			//Evaluate new trial root.
			b += d;
		else		
			b += (xm > 0) ? tol1 : -tol1;
			fb = BlackScholes(spot, b, mat, strike).Price() - price;
	}
	throw("Maximum number of iterations exceeded");
}