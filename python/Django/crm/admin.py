from django.contrib import admin
from . import models
from kingadmin.admin_base import BaseKingAdmin



class CustomerAdmin(admin.ModelAdmin):
    #显示
    list_display = ['name','source','contact_type','contact','consultant','consult_content','status','date']
    #过滤
    list_filter = ['source','consultant','status','date']
    #搜索，consultant是外键，必须加“__字段名”
    search_fields = ['contact','consultant__name']
    #只读字段,不能修改
    # readonly_fields = ['contact','status']
    filter_horizontal = ['consult_courses']
    #每页显示多少条数据
    list_per_page = 8
    #批量操作
    actions = ['change_status',]

    def change_status(self, request, querysets):  # querysets是你选中的所有对象
        querysets.update(status=1)




class StudentAdmin(BaseKingAdmin):
    filter_horizontal = ['class_grades']

admin.site.register(models.Role)
admin.site.register(models.CustomerInfo, CustomerAdmin)
admin.site.register(models.Student)
admin.site.register(models.CustomerFollowUp)
admin.site.register(models.Course)
admin.site.register(models.ClassList)
admin.site.register(models.CourseRecord)
admin.site.register(models.StudyRecord)
admin.site.register(models.Branch)
admin.site.register(models.Menus)
admin.site.register(models.UserProfile)



