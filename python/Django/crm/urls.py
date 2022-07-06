from django.urls import path,re_path
from . import views


urlpatterns = [
    re_path(r'^$', views.dashboard,name='sales_dashboard'),
    # 学员报名
    re_path(r'^stu_enrollment/$', views.stu_enrollment,name='stu_enrollment'),
    # 学员注册
    re_path(r'^enrollment/(\d+)/$', views.enrollment,name='enrollment'),

]
