
%������ ������������: 03.02.10 00:38 
%��������: �.�.������� "�������������� ��������" 
%���: 1 
%���������: 1 
%�����: 11 � ������ 
%�����: 100 
%����: ������������ 
%� �������� ���� ��������� ������������ �������������� ���������, ��� �������� �������� ����� ����� ����. 
%������ ����������� ���� ����� 6 ��. ������� ��3 ���������� ��� �����? (����� ��������� �� ���������� ������ �����.)

hh = 6;
R=[6:1:100];

V0 = 4/3*pi*R.^3;

V1 = 6*pi*(R.^2-(hh/2).^2);

h2 = R - hh/2;
V2 = pi*h2.^2.*(R-h2/3);

V= V0 - V1 - 2*V2;

plot(R,V,'b-');
title('Diofant 318')
xlabel('R, cm');
ylabel('V, cm^3');